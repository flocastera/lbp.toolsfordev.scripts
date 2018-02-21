#!/bin/bash

################################B
# command.sh
# Appel : command/cmd
# Description : Permet d'exécuter une commande dans tous les projets
# Args :
#   Pas d'arguments
################################E

. $ROOT_PATH/functions.sh
export gcol
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

    printProjectInfoTemp "$projectName" "nc"

    callStr="$1 "
    cpt=0
    for param in "$@"
    do
        if [ $cpt -gt 0 ] && [ ! -z "$param" ] ;
        then
            if [ `echo "$param" | grep " " -c` -gt 0 ] ;
            then
                callStr="$callStr\"$param\" "
            else
                callStr="$callStr$param "
            fi
        fi
        let cpt=$cpt+1
    done

    resp=`$callStr 2>&1`

    printProjectInfo "$projectName" "valid"
    echo "$resp" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
    printLine

done

printEnd