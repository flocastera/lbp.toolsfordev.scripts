#!/bin/bash

################################B
# pull.sh
# Appel : pull/gpl
# Description : Permet de mettre à jour le dépot local sur la branche active à partir du dépot distant. Les fichiers mergés seront proposés à la fin du programme
# Args :
#   --stash/-s  : Permet de faire un git stash avant le pull, puis de faire un git stash pop après
#   --detail/-d : Permet d'afficher toutes les sorties de la commande git pull
################################E

. $ROOT_PATH/functions.sh
path="$(pwd)"
pullArgs="$@"

successFilesCount=0
uptodateFilesCount=0
errorsFilesCount=0
mergedFilesCount=0

printHelp "$pullArgs" "pull.sh" "Exécute un Git pull" "pull/gpl" "--stash/-s=Fait un stash avant le pull, puis un stash pop;--detail/-d=Affiche la sortie du git pull" "lbp gpl --stash;lbp pull -sd"

printTitle "Pulling repositories from remote"
printInfo "Arguments : '$(tput setaf 2)$pullArgs$(tput sgr 0)'"
printLine

patterns=`cat $EXCLUDE_GROUP_FILE`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

for projectPath in $loops
do
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    printProjectInfoTemp "$projectName" "nc"

    cd $projectPath

    resultStash=""
    resultPull=""
    resultPop=""
    isStashed="false"
    state=""

    hasArgument "$pullArgs" "stash;s"
    if [ $? -eq 1 ] ;
    then
        # Stashing local changes
        resultStash=`git stash 2>&1`
        isStashed="true"
        if [ `echo "$resultStash" | grep -Eci "no local changes to save"` -gt 0 ] ;
        then
            isStashed="false"
        elif [ `echo "$resultStash" | grep -Eci "index.lock': File exists"` -gt 0 ] ;
        then
		    let "errorsFilesCount = $errorsFilesCount + 1"
            isStashed="false"
            printProjectInfo "$projectName" "error"
            printProjectLine "Unable to stash local changes because .git/index.lock file exists !" "error"
            printLine
            continue
        elif [ `echo "$resultStash" | grep -Eci "(fatal|error)+"` -gt 0 ] ;
        then
		    let "mergedFilesCount = $mergedFilesCount + 1"
            isStashed="false"
            printProjectInfo "$projectName" "error"
            printProjectLine "Unable to stash local changes because of unmerged files !" "nc"
            printProjectLine "Aborting pull for this project !" "nc"
            printProjectLine "Files :"
            echo "$resultStash" | grep -Eoi "^.*needs merge.*$" | sed -E "s/^(\s|\t)*/ ╞─────/g" | sed -E '/^\s*$/d'
            printLine
            continue
        fi
    fi

    # Do the pull
    resultPull=`git pull 2>&1`

    if [ "$isStashed" == "true" ] ;
    then
        # Unstashing local changes
        resultPop=`git stash pop 2>&1`
        if [ `echo "$resultPop" | grep -Eci "conflict"` -gt 0 ] ;
        then
		    let "mergedFilesCount = $mergedFilesCount + 1"
        fi
    fi

    if [ `echo "$resultPull" | grep -ciE "error: the following untracked working tree files"` -gt 0 ] ;
    then
		let "errorsFilesCount = $errorsFilesCount + 1"
        # Overwrite warning
        printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "error"
        if [ "$isStashed" == "true" ] ;
        then
            printProjectLine "Local changes stashed !"
        fi
        printProjectLine "Error ! Files would be overwritten !" "error"

        hasArgument "$pullArgs" "detail;d"
        if [ $? -eq 1 ] ;
        then
            echo "`echo "$resultPull" | sed -E "s/^(\s|\t)*/ ╞───/g" | sed -E '/^\s*$/d'`"
        else
            printProjectLine "Files :"
            files=`echo "$resultPull" | grep -Eio "(\s|\t)*[a-zA-Z]*\/.*\/.*" | sed -E "s/^(\s|\t)*/ ╞─────/g" | sed -E '/^\s*$/d'`
            echo "$(tput setaf 1)$files $(tput sgr 0)"
        fi

        if [ "$isStashed" == "true" ] ;
        then
            printProjectLine "Local changes unstashed !"
        fi
    elif [ `echo "$resultPull" | grep -ic "already up-to-date"` -gt 0 ] ;
    then
		let "uptodateFilesCount = $uptodateFilesCount + 1"
        # Overwrite warning
        printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "valid"
        if [ "$isStashed" == "true" ] ;
        then
            printProjectLine "Local changes stashed !"
        fi
        printProjectLine "Already up-to-date !"
        if [ "$isStashed" == "true" ] ;
        then
            printProjectLine "Local changes unstashed !"
        fi
    else
		let "successFilesCount = $successFilesCount + 1"
        printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "nc"
        if [ "$isStashed" == "true" ] ;
        then
            printProjectLine "Local changes stashed !"
        fi
        files=`echo "$resultPull" | sed -E "s/^(\s|\t)*/ ╞─────/g" | sed -E '/^\s*$/d'`
        echo "$files"
        if [ "$isStashed" == "true" ] ;
        then
            printProjectLine "Local changes unstashed !"
        fi
    fi
    printLine
done

printLine
printResumeStart
printResumeLine "Success" "$successFilesCount" "valid" 11
printResumeLine "Up-to-date" "$uptodateFilesCount" "valid" 11
printResumeLine "Merging" "$mergedFilesCount" "nc" 11
printResumeLine "Errors" "$errorsFilesCount" "error" 11

if [ $mergedFilesCount -gt 0 ] ;
then
    printLine
    read -p " ╞─ There is some unmerged files... Merge them ? (y/n) " merging
    printLine
    if [ "$merging" == "y" ] ;
    then
        for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
        do
            projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
            cd $projectPath
            printProjectInfo "$(tput setaf 2)$projectName$(tput sgr 0)" "valid"
            resultMerge=`git mergetool 2>&1`
            echo "$resultMerge" | sed -E "s/^(\s|\t)*/ ╞────/g" | sed -E '/^\s*$/d'
            printLine
        done
    fi
    printLine
fi
printEnd