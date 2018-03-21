#!/bin/bash

################################B
# merge.sh
# Appel : merge/gbm
# Description : Permet de merger la branche passé en paramètre dans la branche étudiée
# Args :
#   Pas d'arguments
################################E

. $ROOT_PATH/functions.sh
path="$(pwd)"
mergeArgs="$@"

printHelp "$mergeArgs" "merge.sh" "Exécute un Git merge sur la branche passée en paramètre" "merge/gbm" "" "lbp gbm livraison_r5;lbp merge livraison_r5 -X theirs"

if [ $# -gt 0 ];
then

    printTitle "Merging branch '$1' in local branch"
    printInfo "Arguments : '$(tput setaf 2)$mergeArgs$(tput sgr 0)'"
    printLine

    patterns=`cat $EXCLUDE_GROUP_FILE`
    loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

    for projectPath in $loops
    do
        projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
        cd $projectPath
        printProjectInfoTemp "$projectName" "nc"

        result=`git merge $mergeArgs 2>&1`

        if [ `echo "$result" | grep -Eci "(fatal|error)+"` -gt 0 ] ;
        then
            printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "error"
            printProjectLine "Erreur à cause de fichiers non stashés ou commités" "error"
        elif [ `echo "$result" | grep -Eci "(usage:)+"` -gt 0 ] ;
        then
            printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "error"
            printProjectLine "Erreur à cause des arguments passés !" "error"
        elif [ `echo "$result" | grep -c "Already up-to-date"` -gt 0 ] ;
        then
            printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "nc"
            printProjectLine "Déjà à jour..." "nc"
        else
            printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "valid"
            printProjectLine "$(tput setaf 3)$1$(tput sgr 0) merge OK !" "valid"
        fi
        printLine
    done

    printEnd
else
    echo
    echo "$(tput setaf 1)Il faut au moins un argument !$(tput sgr 0)"
    echo
fi