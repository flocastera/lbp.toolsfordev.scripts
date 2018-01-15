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

patterns=`cat $ROOT_PATH/.lbpexclude`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

for projectPath in $loops
do
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    cd $projectPath

    resp=`$args`
    printProjectInfo "$projectName" "valid"
    printLine
    echo "$resp" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
    printLine

done

printEnd