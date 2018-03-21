#!/bin/bash

################################B
# urls.sh
# Appel : urls/ur
# Description : Permet d'afficher ou modifier les urls d'assemblages dans les gcp
# Args :
#   --list/-l   : Liste toutes les urls disponibles et leur emploi
#   --add/-a    : Ajoute une url custom de cette façon : lbp urls -a fca "http://blabla:8080"
################################E

. $ROOT_PATH/functions.sh
args=$@

urlLocal="http://localhost:8080"
urlTas="http://h50-intranetsf-slot1-asse-cc3r5e1-unsecured.service-dev.stomv2.hpmetier.sf.intra.laposte.fr"
urlTfo="http://h50-intranetsf-slot1-tfon-cc3r5e1-unsecured.service-dev.stomv2.hpmetier.sf.intra.laposte.fr"
urlTbeb="http://h50-intranetsf-slot1-tbeb-cc3r5e1-unsecured.service-dev.stomv2.hpmetier.sf.intra.laposte.fr"

urlName=`echo "$args" | grep -E -o "perso=[a-zA-Z0-9]+" | sed 's/perso=//g'`
url=`cat $SCRIPTS_PATH/urlsPerso.txt | grep -E "${urlName}===>.*" | sed "s/${urlName}===>//g"`
#sda => Saoussane ; aka => Amine Kaboussi ; lqu => Lionel Queffelec ;
#urlPersos="sda===>http://331923SSB28.dct.adt.local:8080;aka===>http://331923SS836.dct.adt.local:8080;lqu===>http://331923SSSAZ.dct.adt.local:8080;aas===>http://331923SS616.dct.adt.local:8080;"

printHelp "$args" "urls.sh" "Permet d'afficher ou modifier les urls d'assemblages dans les gcp" "urls/ur" "--list/-l=Liste toutes les urls disponibles et leur emploi;--add/-a=Ajoute une url custom de cette façon : lbp urls -a fca "http://blabla:8080"" "lbp urls tass;lbp urls;lbp urls --list;lbp urls -a fca 'http://ip:8080'"

if [ -z "$args" ] ;
then
    printTitle "Listing urls in all projects' GCP"
else
    if [ "$args" == "tass" ] || [ "$args" == "tfo" ] || [ "$args" == "tpb" ] || [ "$args" == "local" ] || [ `echo "$args" | grep -E "perso=[a-zA-Z0-9]+" -c` -gt 0 ] ;
    then
        printTitle "Changing urls in all projects' GCP to $(tput setaf 3)$args$(tput sgr 0)"
    elif [ `echo "$args" | grep -E "(--add|-a)" -ci` != "0" ] ;
    then
        printTitle "Adding custom url"
    elif [ `echo "$args" | grep -E "(--list|-l)" -ci` != "0" ] ;
    then
        printTitle "Listing all possible urls"
    else
        echo
        printProjectInfo "Exiting because argument is not valid" "error" "'$args'"
        exit
    fi
fi
printInfo "Arguments : '$(tput setaf 2)$args$(tput sgr 0)'"
printLine

totalErrors=0
totalIgnored=0
totalSuccess=0

hasArgument "$args" "add;a"
if [ $? -eq 1 ] ;
then
    if [ "$1" == "--add" ] || [ "$1" == "-a" ] ;
    then
        newKey="$2"
        newUrl="$3"
        echo "$newKey===>$newUrl" >> $SCRIPTS_PATH/urlsPerso.txt
    fi
    exit
fi

hasArgument "$args" "list;l"
if [ $? -eq 1 ] ;
then

    printProjectLine "$(tput setaf 2)War local$(tput sgr 0)          => '$(tput setaf 3)lbp urls local$(tput sgr 0)' => $urlLocal"
    printProjectLine "$(tput setaf 2)Tests d'assemblage$(tput sgr 0) => '$(tput setaf 3)lbp urls tass$(tput sgr 0)'  => $urlTas"
    printProjectLine "$(tput setaf 2)Tests fonctionnels$(tput sgr 0) => '$(tput setaf 3)lbp urls tfo$(tput sgr 0)'   => $urlTfo"
    printProjectLine "$(tput setaf 2)Tests bout en bout$(tput sgr 0) => '$(tput setaf 3)lbp urls tpb$(tput sgr 0)'   => $urlTbeb"
    printLine

    res=`cat $SCRIPTS_PATH/urlsPerso.txt`
    for perso in $res
    do
        urlName=`echo "$perso" | grep -E -o "^[a-zA-Z0-9]+"`
        urlPath=`echo "$perso" | grep -E "===>.*" | sed "s/^.*===>//g"`
        printProjectLine "$(tput setaf 2)$urlName$(tput sgr 0) => '$(tput setaf 3)lbp urls perso=$urlName$(tput sgr 0)' => $urlPath"
    done

    printLine
    printEnd

    exit
fi


patterns=`cat $EXCLUDE_GROUP_FILE`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

for projectPath in $loops
do
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
    printProjectInfoTemp "$projectName" "nc"

    cd $projectPath

    if [ -z "$args" ] ;
    then
        result=`grep -E '^ASSEMBLAGE_HTTP_URL_BASE=.*' $projectPath/src/main/resources/gcp.properties | grep -E '=.*' -o | sed -e "s@^=@@" | grep --color=always -E "//.*"`
        resultTest=`grep -E '^ASSEMBLAGE_HTTP_URL_BASE=.*' $projectPath/src/test/resources/gcp.properties 2>&1 | grep -E '=.*' -o | sed -e "s@^=@@" | grep --color=always -E "//.*"`
        if [ -n "$result" ] ;
        then
            printProjectInfo "$projectName" "valid"
            printProjectLine "Main : $result"
            printProjectLine "Test : $resultTest"
        else
            printProjectInfo "$projectName" "nc" "Pas de GCP ou pas de résultat"
        fi
    else
        if [ "$args" == "tass" ] ;
        then
            printProjectInfo "$projectName" "valid"
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlTas}@g" $projectPath/src/main/resources/gcp.properties 2>&1
            if [ -f $projectPath/src/test/resources/gcp.properties ] ;
            then
                sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlTas}@g" $projectPath/src/test/resources/gcp.properties 2>&1
            fi
        elif [ "$args" == "tfo" ] ;
        then
            printProjectInfo "$projectName" "valid"
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlTfo}@g" $projectPath/src/main/resources/gcp.properties 2>&1
            if [ -f $projectPath/src/test/resources/gcp.properties ] ;
            then
                sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlTfo}@g" $projectPath/src/test/resources/gcp.properties 2>&1
            fi
        elif [ "$args" == "tpb" ] ;
        then
            printProjectInfo "$projectName" "valid"
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlTbeb}@g" $projectPath/src/main/resources/gcp.properties 2>&1
            if [ -f $projectPath/src/test/resources/gcp.properties ] ;
            then
                sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlTbeb}@g" $projectPath/src/test/resources/gcp.properties 2>&1
            fi
        elif [ "$args" == "local" ] ;
        then
            printProjectInfo "$projectName" "valid"
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlLocal}@g" $projectPath/src/main/resources/gcp.properties 2>&1
            if [ -f $projectPath/src/test/resources/gcp.properties ] ;
            then
                sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlLocal}@g" $projectPath/src/test/resources/gcp.properties 2>&1
            fi
        elif [ `echo "$args" | grep -E "perso=[a-zA-Z0-9]+" -c` -gt 0 ] && [ ! -z "$url" ] ;
        then
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${url}@g" $projectPath/src/main/resources/gcp.properties 2>&1
            if [ -f $projectPath/src/test/resources/gcp.properties ] ;
            then
                sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${url}@g" $projectPath/src/test/resources/gcp.properties 2>&1
            fi
            printProjectInfo "$projectName" "valid"
        else
            printProjectInfo "$projectName" "error"
        fi
    fi

    printLine

done

printEnd