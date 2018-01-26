#!/bin/bash

################################B
# pom.sh
# Appel : pom/pm
# Description : Permet de dresser la liste des versions des pom.xml, ainsi que les dépendances
# Args :
#   --all/-a        : Permet d'afficher les dépendances pour chaque projet
#   --sync/-s       : Permet de synchroniser les verions des dépendances avec les pom.xml des projects locaux
#   --increment/-i  : Permet d'incrémenter de 1 la version de tous les poms (--snapshot pour ajouter le suffixe -SNAPSHOT)
################################E

. $ROOT_PATH/functions.sh
path="$(pwd)"
args=$@

printHelp "$args" "pom.sh" "Ce script permet de dresser la liste des versions" "pom/po" "--full/-f=Affiche les dépendances;--sync/-s=Synchronise les dépendances" "lbp pom --sync;lbp pom;lbp pom -f"

hasArgument "$args" "all;a"
if [ $? -eq 1 ] || [ -z "$args" ] ;
then
    printTitle "Getting POM version for all projects"

    hasArgument "$args" "full;f"
    if [ $? -eq 1 ] ;
    then
        printInfo "$(tput setaf 2)Will print dependencies$(tput sgr 0)"
    fi
    printLine

    patterns=`cat $ROOT_PATH/.lbpexclude`
    loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

    for projectPath in $loops
    do
        cd $projectPath
        projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

        res="$(grep -E "<version>.*</version>" pom.xml -m 2 | tail -1)"
        res=${res:11}
        res="$(echo $res | sed 's/.\{10\}$//')"

        printProjectInfo $projectName "valid" `echo "$res" | grep --color=always -E "[0-9]{2,3}\-.*"`

        hasArgument "$args" "all;a"
        if [ $? -eq 1 ] ;
        then
            res="$(awk '/<properties>/,/<\/properties>/' pom.xml | grep -Eo '(composant\-applicatif|module)+\-[a-zA-Z0-9]+.*>0[0-9]{1}_[0-9]{2}_[0-9]{2}\.[0-9]{2,3}(\-SNAPSHOT){0,1}' pom.xml | sed 's/.adb.version>/ /g ' | sort  | sed 's/composant-applicatif-/ ╞───/g ')"
            if [ $(echo "$res" | sed '/^\s*$/d' | wc -l) -gt 0 ] ;
            then
                echo "$res" | grep --color -E '[0-9]{2,3}(\-.*|$)'
            fi
        fi
        printLine
    done
    printEnd
fi


hasArgument "$args" "sync;s"
if [ $? -eq 1 ] ;
then
    printTitle "Synchronizing POM dependencies version for all projects"
    printInfo "$(tput setaf 3)Ne pas utiliser Ctrl+C, ou alors supprimer le fichier tmpFile à la racine$(tput sgr 0)"
    printLine

    patterns=`cat $ROOT_PATH/.lbpexclude`
    loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

    tempFile="$WSP_PATH/tmpFile"
    for project in $loops
    do
        chem="$project/pom.xml"
        pomVersion="$(grep -E '<version>.*</version>' $chem -m 2 | tail -1 | sed -e 's@.*<version>@@g' | sed -e 's@</version>.*@@g')"
        echo "$(echo $project | grep -Eo '[a-zA-Z0-9-]+$' | awk '{print tolower($0)}' | sed 's@composants@composant@g' | sed 's@applicatifs@applicatif@g' | sed 's@formules@formule@g' | sed 's@autres@autre@g' | sed 's@produits@produit@g'):$pomVersion" >> $tempFile
    done
    for project in $loops
    do
        chem="$project/pom.xml"
        dependencies=`awk '/<properties>/,/<\/properties>/' $chem | grep -Eo '(composant\-applicatif|module)+\-[a-zA-Z0-9]+.*>0[0-9]{1}_[0-9]{2}_[0-9]{2}\.[0-9]{2,3}(\-SNAPSHOT){0,1}' | grep -Eo '(composant\-applicatif|module)+\-[a-zA-Z0-9]+' | sed 's@(\s)+$@@g'`

        if [ $(echo "$dependencies" | sed '/^\s*$/d' | wc -l) -gt 0 ] ;
        then
            minProject=`echo $project | grep -Eo '[a-zA-Z0-9-]+$' | grep -Eo '(H[0-9]{2}\-)?[a-zA-Z]*$'`
            updated=0
            errors=0

            printProjectInfo "$minProject" "valid"

            for dependency in $dependencies
            do
                minDep=`echo "$dependency" | awk '{print tolower($0)}'`
                correspondingProject=`cat $tempFile | grep $minDep`
                depName=`echo $dependency | grep -Eo '[a-zA-Z0-9-]+$' | grep -Eo '(H[0-9]{2}\-)?[a-zA-Z]*$'`
                if [ $(echo "$correspondingProject" | sed '/^\s*$/d' | wc -l) -gt 0 ] ;
                then
		            let updated=$updated+1
                    correspondingVersion=`echo "$correspondingProject" | grep -Eo '0[0-9]{1}_[0-9]{2}_[0-9]{2}\.[0-9]{2,3}(\-SNAPSHOT){0,1}'`
                    sed -i -e "s@<$dependency\.adb\.version>.*</$dependency\.adb\.version>@<$dependency.adb.version>${correspondingVersion}<\\/$dependency.adb.version>@g" $chem
                    printProjectLine "$depName updated to $(tput setaf 2)$correspondingVersion$(tput sgr 0)" "valid"

                else
		            let errors=$errors+1
                    printProjectLine "$depName not updated" "nc"
                fi
            done

            printLine
        fi
    done
    printEnd
    rm -rf $tempFile
fi

hasArgument "$args" "increment;i"
if [ $? -eq 1 ] ;
then
    printTitle "Incrementing POM versions version for all projects"
    printLine
    updated=0
    errors=0

    for pom in `find $WSP_PATH -maxdepth 2 -type f | grep -E "pom.xml"`
    do
        pomVersion="$(grep -E '<version>.*</version>' $pom -m 2 | tail -1 | sed -e 's@.*<version>@@g' | sed -e 's@</version>.*@@g')"
        pomVersionExt=`echo "$pomVersion" | grep -E '[0-9]{2,3}(\-SNAPSHOT)$' -o | grep -E '^[0-9]{2,3}' -o | grep -E '[0-9]{2}$' -o`
        let newPomVersion="$pomVersionExt + 1"

        hasArgument "$args" "snapshot"
        if [ $? -eq 1 ] ;
        then
            newPomVersion="0$newPomVersion-SNAPSHOT"
        else
            newPomVersion="0$newPomVersion"
        fi
        pomVersionStr=`echo "$pomVersion" | grep -E '^[0-9]{2}_[0-9]{2}_[0-9]{2}\.' -o`
        pomVersionFinal=`echo "$pomVersionStr$newPomVersion"`
        sed -i -e "s@<version>$pomVersion</version>@<version>${pomVersionFinal}<\\/version>@g" $pom
        projectName=$(echo $pom | grep -Eo "$projectNamePatterns")
        if [ `grep "<version>$pomVersionFinal</version>" -c $pom` -gt 0 ] ;
        then
            printProjectInfo "$projectName" "valid" "incremented to $(tput setaf 2)$pomVersionFinal$(tput sgr 0)"
            let updated=$updated+1
        else
            let errors=$errors+1
            printProjectInfo "$projectName" "nc" "not incremented"
        fi
        printLine
    done
    printResumeStart
    printResumeLine "Incremented" "$updated" "valid" 12
    printResumeLine "Ignored" "$errors" "nc" 12
    printEnd
fi