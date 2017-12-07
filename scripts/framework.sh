#!/bin/bash

################################
# framework.sh
# Appel : framework/fw
# Description : Permet d'afficher ou de mettre à jour les versions des frameworks
# Args :
#   --update/-u : permet de mettre à jour les frameworks
#       ex : --update/-u fwad 4.5.5
################################

. $WSP_PATH/lbp.toolsfordev.scripts/functions.sh
path="$(pwd)"
args=$@

printHelp "$args" "framework.sh" "Affiche ou modifie les différentes versions des frameworks" "framework/fw" "--update/-u=Modifie la version du framework passé en paramètre" "lbp fw fwad 2.5.4;lbp fw fwmc 4.4.5;lbp framework toolbox 2.5.14"

if [ -z "$args" ] ;
then
    printTitle "Getting Frameworks versions for all projects"
    printInfo "Affiche de la façon suivante : pom.xml / index.template.html / index.html"
    printLine

    for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
    do
        cd $projectPath
        projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
        printProjectInfo $projectName "valid"

        pomFwmc=`grep -E "<fwmc.adb.version>.*</fwmc.adb.version>" pom.xml | grep -o ">.*<" | grep -E -o "[0-9\.]+" --color=always`
        pomFwad=`grep -E "<fwad.adb.version>.*</fwad.adb.version>" pom.xml | grep -o ">.*<" | grep -E -o "[0-9\.]+" --color=always`
        pomToolbox=`grep -E " <toolbox.adb.version>.*</toolbox.adb.version>" pom.xml | grep -o ">.*<" | grep -E -o "[0-9\.]+" --color=always`
        htmlFile=`find $projectPath/src/main/resources/public/ -maxdepth 2 -type f | grep 'index.template.html'`
        htmlIndexFile=`find $projectPath/src/main/resources/public/ -maxdepth 2 -type f | grep 'index.html'`
        if [ -n "$htmlFile" ] ;
        then
            htmlFwad=`grep -E "<script.*src=\".*/fwad/.*\">" $htmlFile | grep -E -o "/[0-9\.]+/" | grep -E -o "[0-9\.]+" --color=always`
            htmlToolbox=`grep -E "<script.*src=\".*/cc3toolbox/.*\">" $htmlFile | grep -E -o "/[0-9\.]+/" | grep -E -o "[0-9\.]+" --color=always`
        fi
        if [ -n "$htmlIndexFile" ] ;
        then
            htmlIndexFwad=`grep -E "<script.*src=\".*/fwad/.*\">" $htmlIndexFile | grep -E -o "/[0-9\.]+/" | grep -E -o "[0-9\.]+" --color=always`
            htmlIndexToolbox=`grep -E "<script.*src=\".*/cc3toolbox/.*\">" $htmlIndexFile | grep -E -o "/[0-9\.]+/" | grep -E -o "[0-9\.]+" --color=always`
        fi

        if [ -n "$pomToolbox" ] ;
        then
            printProjectLine "Toolbox ==> $pomToolbox / $htmlToolbox / $htmlIndexToolbox"
        fi
        if [ -n "$pomFwad" ] ;
        then
            printProjectLine "FwAD    ==> $pomFwad / $htmlFwad / $htmlFwad"
        fi
        if [ -n "$pomFwmc" ] ;
        then
            printProjectLine "FwMC    ==> $pomFwmc"
        fi
        printLine
    done
    printEnd
fi

hasArgument "$args" "update;u"
if [ $? -eq 1 ] ;
then
    typeUpdate=`echo "$args" | grep -E -o "(fwad|fwmc|toolbox)+"`
    printTitle "Updating frameworks versions for all projects"
    if [ `echo "$typeUpdate" | sed '/^\s*$/d' | wc -l` -eq 0 ] ;
    then
        printInfo "S'utilise de la façon suivante : lbp -u <type> <version>"
        printInfo "──> <type> : fwad/fwmc/toolbox"
        printInfo "Sortie du programme !"
    else
        numVersion=`echo "$args" | grep -E -o "(fwad|fwmc|toolbox)+\s[0-9\.]+" | grep -E -o "[0-9\.]+"`
        if [ `echo "$typeUpdate" | sed '/^\s*$/d' | wc -l` -eq 0 ] ;
        then
            printInfo "$(tput setaf 1)Pas de version renseignée...$(tput sgr 0)"
            printInfo "Sortie du programme !"
        else
            printInfo "Mise à jour : $(tput setaf 2)$typeUpdate$(tput sgr 0) à la version $(tput setaf 2)$numVersion$(tput sgr 0)"
            printLine

            for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
            do
                cd $projectPath
                projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
                pathHtmls="./src/main/resources/public/`echo $projectName | awk '{print tolower($0)}'`"
                result=""

                if [ $typeUpdate == "fwad" ] ;
                then
                    searchPom="<fwad\.adb\.version>.*</fwad\.adb\.version>"
                    searchHtml="src=\"\.\./webjars/fwad/.*/FwAD\.min\.js\""

                    replacementPom="<fwad\.adb\.version>$numVersion</fwad\.adb\.version>"
                    replacementHtml="src=\"\.\./webjars/fwad/$numVersion/FwAD\.min\.js\""

                    result="$result`sed -i -e "s@$searchPom@$replacementPom@g" pom.xml 2>&1`"
                    result="$result`sed -i -e "s@$searchHtml@$replacementHtml@g" $pathHtmls/index.html 2>&1`"
                    result="$result`sed -i -e "s@$searchHtml@$replacementHtml@g" $pathHtmls/index.template.html 2>&1`"
                elif [ $typeUpdate == "toolbox" ] ;
                then
                    searchPom="<toolbox\.adb\.version>.*</toolbox\.adb\.version>"
                    searchJS="src=\"\.\./webjars/cc3toolbox/.*/js/toolbox\-bundle\.min\.js\""
                    searchCSS="href=\"\.\./webjars/cc3toolbox/.*/styles/css/bundle/toolbox\-bundle\.min\.css\""

                    replacementPom="<toolbox\.adb\.version>$numVersion</toolbox\.adb\.version>"
                    replacementJS="src=\"\.\./webjars/cc3toolbox/$numVersion/js/toolbox\-bundle\.min\.js\""
                    replacementCSS="href=\"\.\./webjars/cc3toolbox/$numVersion/styles/css/bundle/toolbox\-bundle\.min\.css\""

                    result="$result`sed -i -e "s@$searchPom@$replacementPom@g" pom.xml 2>&1`"
                    result="$result`sed -i -e "s@$searchJS@$replacementJS@g" $pathHtmls/index.html 2>&1`"
                    result="$result`sed -i -e "s@$searchCSS@$replacementCSS@g" $pathHtmls/index.html 2>&1`"
                    result="$result`sed -i -e "s@$searchJS@$replacementJS@g" $pathHtmls/index.template.html 2>&1`"
                    result="$result`sed -i -e "s@$searchCSS@$replacementCSS@g" $pathHtmls/index.template.html 2>&1`"
                elif [ $typeUpdate == "fwmc" ] ;
                then
                    searchPom="<fwmc\.adb\.version>.*</fwmc\.adb\.version>"
                    replacementPom="<fwmc\.adb\.version>$numVersion</fwmc\.adb\.version>"

                    result="$result`sed -i -e "s@$searchPom@$replacementPom@g" pom.xml 2>&1`"
                fi
                result=`echo "$result" | sed '/^\s*$/d'`

                if [ `echo "$result" | grep "No such file or directory" -c` -gt 0 ] ;
                then
                    printProjectInfo $projectName "nc"
                    printProjectLine "pom.xml à jour à la version $(tput setaf 2)$numVersion $(tput sgr 0)" "valid"
                    printProjectLine "Certains fichiers sont introuvables dans le projet" "nc"
                else
                    printProjectInfo $projectName "valid"
                    printProjectLine "Mise à jour à la version $(tput setaf 2)$numVersion $(tput sgr 0)"
                fi

                printLine
            done
        fi
        printEnd
    fi
fi