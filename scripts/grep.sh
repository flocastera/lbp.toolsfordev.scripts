#!/bin/bash

################################B
# grep.sh
# Appel : grep/grp
# Description : Permet de trouver toutes les occurences d'une expression dans tous les projets
# Args :
#   --hide/-h   : Permet de cacher les fichiers à ne pas commiter (AccreditationService, SecurityBouchonConfig, pom.xml, ...)
#   --update/-u : Permet de rafraichir le dépôt local et indique s'il est à jour ou derrière/devant le dépot distant
#   --branch/-b : Permet d'afficher la branche courante
################################E

. $ROOT_PATH/functions.sh

defaultArgs="-nR --color=always $3 $4 $5"
exludesPaths="--exclude-dir=\.(git|classpath|externalToolBuilders|project|settings) --exclude-dir=node_modules --exclude-dir=target --exclude=npm-debug.log --exclude=*.log"
grepSearch="$1"
args="$1 $2 $3 $4 $5"

totalMatchCount=0
totalMatchProject=0
matchProjects=""
dumpfile="$WSP_PATH/grep_results.txt"

printHelp "$1 $2 $3 $4 $5" "grep.sh" "Exécute un Git status dans tous les projets" "status/gst" "--hide/-h=Cacher les fichiers non voulus (pom.xml, .properties, ...);--update/-u=Rafraichit l'état par rapport au dépot distant;--branch/-b=Affiche la branche active" "lbp status --hide;lbp status -hub"

printTitle "Searching occurences in projects"
printInfo "Search : '$(tput setaf 2)$grepSearch$(tput sgr 0)'"
printInfo "Exclude : '$(tput setaf 3)$exludesPaths$(tput sgr 0)'"
printInfo "Args : '$defaultArgs'"
printLine

patterns=`cat $EXCLUDE_GROUP_FILE`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

for projectPath in $loops
do
    cd $projectPath
    projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
    printProjectInfoTemp "$projectName" "nc"


    result=`grep $defaultArgs $exludesPaths $grepSearch`
    let "count=`echo "$result" | sed '/^\s*$/d' | wc -l`"

    if [ $count -gt 0 ] ;
    then
        printProjectInfo "$projectName" "valid"
        let "totalMatchCount = $totalMatchCount + $count"
        let "totalMatchProject = $totalMatchProject + 1"
        matchProjects="$projectName, $matchProjects"


        hasArgument "$args" "count;c"
        if [ $? -eq 1 ] ;
        then
            printProjectLine "Matches : $count" "nc"
            echo "" >> $dumpfile
            echo "===================[ $projectName ]===================" >> $dumpfile
            echo "" >> $dumpfile
            grep $defaultArgs $exludesPaths $grepSearch >> $dumpfile
            echo "" >> $dumpfile
            printLine
            continue
        fi

        hasArgument "$args" "count-only;"
        if [ $? -eq 1 ] ;
        then
            printProjectLine "Matches : $count" "nc"
            printLine
            continue
        fi

        hasArgument "$args" "matches;m"
        if [ $? -eq 1 ] ;
        then
            grep $defaultArgs $exludesPaths $grepSearch | sed -e "s/[[:space:]]\+/ /g" | sed "s/fr.laposte.disf.canal/.../g" | sed -e "s@src/main@@g" | sed 's/^/ ╞───/g'
            printProjectLine "Matches : $count" "nc"
            printLine
            continue
        fi

        printLine
    else
        printProjectInfo "$projectName" "error"
        printLine
    fi
done
printResumeStart
printResumeLine "Total count" "$totalMatchCount" "" 14
printResumeLine "Total project" "$totalMatchProject" "" 14
printResumeLine "Projects" "$matchProjects" "nc" 14
printEnd

hasArgument "$args" "count;c"
if [ $? -eq 1 ] ;
then
    echo
    read -p "Voir les résultats ? (y/n) " resp
    if [ "$resp" == "y" ] ;
    then
        echo
        cat $dumpfile | sed -e "s/[[:space:]]\+/ /g" | sed "s/fr.laposte.disf.canal/.../g" | sed -e "s@src/main@@g"
    fi
fi
rm -f $dumpfile &> /tmp/tmp