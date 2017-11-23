#!/bin/bash


. $WSP_PATH/lbp.toolsfordev.scripts/functions.sh
path="$(pwd)"
args=$@

hasArgument $args "full;f"
if [ $? -eq 1 ] || [ "$args" == "0" ] ;
then
    printTitle "Getting POM version for all projects"

    hasArgument $args "full;f"
    if [ $? -eq 1 ] ;
    then
        printInfo "$(tput setaf 2)Will print dependencies$(tput sgr 0)"
    fi
    printLine

    for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
    do
        cd $projectPath
        projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

        res="$(grep -E "<version>.*</version>" pom.xml -m 2 | tail -1)"
        res=${res:11}
        res="$(echo $res | sed 's/.\{10\}$//')"

        printProjectInfo $projectName "valid" `echo "$res" | grep --color=always -E "[0-9]{2,3}\-.*"`

        hasArgument $args "full;f"
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


hasArgument $args "sync;s"
if [ $? -eq 1 ] ;
then
    printTitle "Synchronizing POM dependencies version for all projects"
    printInfo "$(tput setaf 3)Ne pas utiliser Ctrl+C, ou alors supprimer le fichier tmpFile à la racine$(tput sgr 0)"
    printLine

    projects=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
    tempFile="$WSP_PATH/tmpFile"
    for project in $projects
    do
        chem="$project/pom.xml"
        pomVersion="$(grep -E '<version>.*</version>' $chem -m 2 | tail -1 | sed -e 's@.*<version>@@g' | sed -e 's@</version>.*@@g')"
        echo "$(echo $project | grep -Eo '[a-zA-Z0-9-]+$' | awk '{print tolower($0)}' | sed 's@composants@composant@g' | sed 's@applicatifs@applicatif@g' | sed 's@formules@formule@g' | sed 's@autres@autre@g' | sed 's@produits@produit@g'):$pomVersion" >> $tempFile
    done
    for project in $projects
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