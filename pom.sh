#!/bin/bash

path="$(pwd)"
if [ "$#" == "0" ] || [ "$1" == "--full" ] || [ "$1" == "-f" ] ;
then
    echo
    echo "$(tput setaf 2)Getting POM version for all projects...$(tput sgr 0)"
    echo "─┬─────────────────────────────────────────"
    if [ "$1" == "--full" ] || [ "$1" == "-f" ] ;
    then
        echo " ╞──$(tput setaf 2)Will print dependencies$(tput sgr 0)"
    fi
    echo " │"

    for projectPath in `find $WSP_PATH -maxdepth 1 -type d`
    do
        test="$(echo $projectPath | grep -E "$watchPatterns" -c)"
        if [ $test -eq 1 ]
        then
            cd $projectPath
		    projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

            echo -n "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0) : "

            res="$(grep -E "<version>.*</version>" pom.xml -m 2 | tail -1)"
            res=${res:11}
            res="$(echo $res | sed 's/.\{10\}$//')"
            echo $res | grep --color -E "[0-9]{2,3}\-.*"
            if [ "$1" == "--full" ] || [ "$1" == "-f" ] ;
            then
                res="$(awk '/<properties>/,/<\/properties>/' pom.xml | grep -Eo '(composant\-applicatif|module)+\-[a-zA-Z0-9]+.*>0[0-9]{1}_[0-9]{2}_[0-9]{2}\.[0-9]{2,3}(\-SNAPSHOT){0,1}' pom.xml | sed 's/.adb.version>/ /g ' | sort  | sed 's/composant-applicatif-/ ╞───/g ')"
                if [ $(echo "$res" | sed '/^\s*$/d' | wc -l) -gt 0 ] ;
                then
                    echo "$res" | grep --color -E '[0-9]{2,3}(\-.*|$)'
                fi
            fi
            echo " │"
        fi
    done
    echo " ╘─────────────────────────────────────────────"
fi
if [ "$1" == "--sync" ] || [ "$1" == "-s" ] ;
then
    echo
    echo "$(tput setaf 2)Synchronizing POM dependencies version for all projects...$(tput sgr 0)"
    echo "─┬─────────────────────────────────────────────────────"
    echo " │"

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
            echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$minProject$(tput sgr 0)"
            updated=0
            errors=0
            for dependency in $dependencies
            do
                minDep=`echo "$dependency" | awk '{print tolower($0)}'`
                correspondingProject=`cat $tempFile | grep $minDep`
                depName=`echo $dependency | grep -Eo '[a-zA-Z0-9-]+$' | grep -Eo '(H[0-9]{2}\-)?[a-zA-Z]*$'`
                if [ $(echo "$correspondingProject" | sed '/^\s*$/d' | wc -l) -gt 0 ] ;
                then
		            let "updated = $updated + 1"
                    correspondingVersion=`echo "$correspondingProject" | grep -Eo '0[0-9]{1}_[0-9]{2}_[0-9]{2}\.[0-9]{2,3}(\-SNAPSHOT){0,1}'`
                    sed -i -e "s@<$dependency\.adb\.version>.*</$dependency\.adb\.version>@<$dependency.adb.version>${correspondingVersion}<\\/$dependency.adb.version>@g" $chem
                    echo " $(tput setaf 2)╞───$(tput sgr 0)$depName updated to $(tput setaf 2)$correspondingVersion$(tput sgr 0)"
                else
		            let "errors = $errors + 1"
                    echo " $(tput setaf 3)╞───$(tput sgr 0)$depName not updated"
                fi
            done
            echo " │"
        fi
    done
    echo " ╘─────────────────────────────────────────────────────"
    rm -rf $tempFile
fi