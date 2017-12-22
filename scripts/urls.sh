#!/bin/bash

################################B
# urls.sh
# Appel : urls/ur
# Description : Permet d'afficher ou modifier les urls d'assemblages dans les gcp
# Args :
#   Pas d'arguments
################################E

. $ROOT_PATH/functions.sh
args=$@

urlLocal="http://localhost:8080"
urlTas="http://h50-intranetsf-slot1-asse-cc3r5e1-unsecured.service-dev.stomv2.hpmetier.sf.intra.laposte.fr"
urlTfo="http://h50-intranetsf-slot1-tfon-cc3r5e2-unsecured.service-dev.stomv2.hpmetier.sf.intra.laposte.fr"
urlPersos="sda===>http://331923SSB28.dct.adt.local:8080;"

printHelp "$args" "urls.sh" "Permet d'afficher ou modifier les urls d'assemblages dans les gcp" "urls/ur" "Pas d'arguments" "lbp urls tass"

hasArgument "$args" "list;l"
if [ $? -eq 1 ] ;
then
    printTitle "Listing urls in all projects' GCP"
else
    printTitle "Changing urls in all projects' GCP"
fi
printInfo "Arguments : '$(tput setaf 2)$args$(tput sgr 0)'"
printLine

totalErrors=0
totalIgnored=0
totalSuccess=0

for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

	## Comment/uncomment in repositories.txt to break loop for projects
    exclude=`grep "${projectName}" $repositoriesList |  grep '\-\-' -c`
    if [ $exclude -gt 0 ] ;
    then
        continue
    fi

    cd $projectPath

    if [ -z "$args" ] ;
    then
        result=`grep -E '^ASSEMBLAGE_HTTP_URL_BASE=.*' $projectPath/src/main/resources/gcp.properties | grep -E '=.*' -o | sed -e "s@^=@@" | grep --color=always -E "//.*"`
        if [ -n "$result" ] ;
        then
            printProjectInfo "$projectName" "valid"
            printProjectLine "$result"
        else
            printProjectInfo "$projectName" "nc" "Pas de GCP ou pas de résultat"
        fi
    else
        if [ "$args" == "tass" ] ;
        then
            printProjectInfo "$projectName" "valid" "Changed to $(tput setaf 3)TASS$(tput sgr 0) url"
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlTas}@g" $projectPath/src/main/resources/gcp.properties
        elif [ "$args" == "tfo" ] ;
        then
            printProjectInfo "$projectName" "valid" "Changed to $(tput setaf 3)TFO$(tput sgr 0) url"
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlTfo}@g" $projectPath/src/main/resources/gcp.properties
        elif [ "$args" == "local" ] ;
        then
            printProjectInfo "$projectName" "valid" "Changed to $(tput setaf 3)LOCAL$(tput sgr 0) url"
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${urlLocal}@g" $projectPath/src/main/resources/gcp.properties
        elif [ `echo "$args" | grep -E "perso=[a-zA-Z0-9]+" -c` -gt 0 ] ;
        then
            urlName=`echo "$args" | grep -E -o "perso=[a-zA-Z0-9]+" | sed 's/perso=//g'`
            url=`echo "$urlPersos" | tr ';' '\n' | grep -E "${urlName}===>.*" | sed "s/${urlName}===>//g"`
            sed -i -e "s@^ASSEMBLAGE_HTTP_URL_BASE=.*@ASSEMBLAGE_HTTP_URL_BASE=${url}@g" $projectPath/src/main/resources/gcp.properties
            printProjectInfo "$projectName" "valid" "Changed to $(tput setaf 3)$urlName$(tput sgr 0) ($url)"
        fi
    fi

    printLine

done

printEnd