#!/bin/bash

################################B
# branch.sh
# Appel : branch/gbr
# Description : Permet de passer à la branche passé en paramètre
# Args :
#   Pas d'arguments
################################E

. $ROOT_PATH/functions.sh
path="$(pwd)"
mergeArgs="$@"

printHelp "$mergeArgs" "branch.sh" "Exécute une action Git relative aux branches" "branch/gbr" "" "lbp gbr livraison_r5;lbp branch <nouvelle_branche> -b"

    if [ $# -gt 0 ];
    then

    printTitle "Switching branch to branch '$1'"
    printInfo "Arguments : '$(tput setaf 2)$mergeArgs$(tput sgr 0)'"
    printLine

    patterns=`cat $EXCLUDE_GROUP_FILE`
    loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

    for projectPath in $loops
    do
        projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
        cd $projectPath


        result=""
        hasArgument "$mergeArgs" "a;d;r"
        if [ $? -eq 1 ] ;
        then
            result=`git branch $mergeArgs 2>&1`
        fi
        hasArgument "$mergeArgs" "b"
        if [ $? -eq 1 ] || [ $# -eq 1 ] ;
        then
            result=`git checkout $mergeArgs 2>&1`
        fi

        if [ `echo "$result" | grep -Eci "(fatal|error)+"` -gt 0 ] ;
        then
            printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "error"
            printProjectLine "Erreur à cause de fichiers non commités ou branche non existante" "error"
        elif [ `echo "$result" | grep -Eci "(usage:)+"` -gt 0 ] ;
        then
            printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "error"
            printProjectLine "Erreur à cause des arguments passés !" "error"
        else
            printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "valid" "OK"
        fi
        printLine
    done

    printEnd
else
    echo
    echo "$(tput setaf 1)Il faut au moins un argument !$(tput sgr 0)"
    echo
fi