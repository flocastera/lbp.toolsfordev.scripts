#!/bin/bash

################################B
# command.sh
# Appel : command/cmd
# Description : Permet d'exécuter une commande dans tous les projets
# Args :
#   Pas d'arguments
################################E

. $ROOT_PATH/functions.sh
args=$@

printHelp "$args" "command.sh" "Exécute une commande dans tous les répertoires" "command/cmd" "Pas d'arguments" "lbp command ls -l"

printTitle "Executing commands in all projects"
printInfo "Commands : '$(tput setaf 2)$args$(tput sgr 0)'"
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

    resp=`$args`
    printProjectInfo "$projectName" "valid"
    printLine
    echo "$resp" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
    printLine

done

printEnd