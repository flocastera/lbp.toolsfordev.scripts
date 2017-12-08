#!/bin/bash

################################B
# status.sh
# Appel : status/gst
# Description : Permet de dresser la liste des fichiers modifiés de la même manière que la commande git status
# Args :
#   --hide/-h   : Permet de cacher les fichiers à ne pas commiter (AccreditationService, SecurityBouchonConfig, pom.xml, ...)
#   --update/-u : Permet de rafraichir le dépôt local et indique s'il est à jour ou derrière/devant le dépot distant
#   --branch/-b : Permet d'afficher la branche courante
################################E

. $WSP_PATH/lbp.toolsfordev.scripts/functions.sh
args=$@

path="$(pwd)"
totalFilesCount=0
modifiedFilesCount=0
addedFilesCount=0
deletedFilesCount=0
mergedFilesCount=0

printHelp "$args" "status.sh" "Exécute un Git status dans tous les projets" "status/gst" "--hide/-h=Cacher les fichiers non voulus (pom.xml, .properties, ...);--update/-u=Rafraichit l'état par rapport au dépot distant;--branch/-b=Affiche la branche active" "lbp status --hide;lbp status -hub"

printTitle "Getting status for projects"
printInfo "Arguments : '$(tput setaf 2)$args$(tput sgr 0)'"
printLine

# Looping over directories in Workspace path
for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
    cd $projectPath # Going into project folder to execute Git commands
    projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    statusToRemote=""
    branch=""

    hasArgument "$args" "update;u"
    if [ $? -eq 1 ] ;
    then
        nullll=`git remote update 2>&1`
        statusToRemote=`git status -uno | grep -Eo -m 1 "(up\-to\-date|behind|ahead)+"`
        if [ -n "$statusToRemote" ] ;
        then
            statusToRemote="$statusToRemote to 'origin'"
        else
            statusToRemote=""
        fi
    fi

    hasArgument "$args" "branch;b"
    if [ $? -eq 1 ] ;
    then
        branch=`git rev-parse --abbrev-ref HEAD`
        branch="on branch $(tput setaf 3)$branch$(tput sgr 0)"
    fi

    result=`git status -s`                                  # Getting general status for project
    resultModified=`echo "$result" | grep -E "^(\s)?M.*"`   # Getting modified files
    resultAdded=`echo "$result" | grep -E "^(\s)?A.*"`      # Getting added files
    resultDeleted=`echo "$result" | grep -E "^(\s)?D.*"`    # Getting deleted files
    resultUnknown=`echo "$result" | grep -E "^(\s)?\?.*"`   # Getting merged/merging files
    total=$(echo "$result" | sed '/^\s*$/d' | wc -l)        # Calculating total

    hasArgument "$args" "hide;h"
    if [ $? -eq 1 ] ;
    then
        # Re-calculate status with some files excluded
        result=`echo "$result" | grep -Ev "$excludedProjectPathsPatterns"`
        resultModified=`echo "$result" | grep -E "^(\s)?M.*"`
        resultAdded=`echo "$result" | grep -E "^(\s)?A.*"`
        resultDeleted=`echo "$result" | grep -E "^(\s)?D.*"`
        resultUnknown=`echo "$result" | grep -E "^(\s)?\?.*"`
        total=$(echo "$result" | sed '/^\s*$/d' | wc -l)
    fi

    # Display and total calculation
    if [ "$total" != "0" ] ;
    then
        printProjectInfo "$projectName" "error" "$branch" "$statusToRemote"

        let "totalFilesCount = $totalFilesCount + $total"

        if [ "$resultAdded" != "" ] ;
        then
            echo "$(tput setaf 2)`echo "$resultAdded" | sed "s/^/ ╞──/g "`$(tput sgr 0)"
            let "addedFilesCount = $addedFilesCount + `echo "$resultAdded" | wc -l`"
        fi

        if [ "$resultModified" != "" ] ;
        then
            added=`echo "$resultModified" | grep -E "^M.*"`
            notAdded=`echo "$resultModified" | grep -E "^\sM.*"`

            let "modifiedFilesCount = $modifiedFilesCount + `echo "$resultModified" | wc -l`"

            # Modified files can either be added to commit or not
            if [ "$added" != "" ] ;
            then
                echo "$(tput setaf 2)`echo "$added" | sed "s/^/ ╞──/g "`$(tput sgr 0)"
            fi
            if [ "$notAdded" != "" ] ;
            then
                echo "$(tput setaf 1)`echo "$notAdded" | sed "s/^/ ╞──/g "`$(tput sgr 0)"
            fi
        fi

        if [ "$resultDeleted" != "" ] ;
        then
            echo "$(tput setaf 1)`echo "$resultDeleted" | sed "s/^/ ╞──/g "`$(tput sgr 0)"
            let "deletedFilesCount = $deletedFilesCount + `echo "$resultDeleted" | wc -l`"
        fi

        if [ "$resultUnknown" != "" ] ;
        then
            echo "$(tput setaf 3)`echo "$resultUnknown" | sed "s/^/ ╞──/g "`$(tput sgr 0)"
            let "mergedFilesCount = $mergedFilesCount + `echo "$resultUnknown" | wc -l`"
        fi
        printLine
    else
        printProjectInfo "$projectName" "valid" "$branch" "$statusToRemote"
        printLine
    fi
done

printResumeStart
if [ "$totalFilesCount" == "0" ] ;
then
    printInfo "$(tput setaf 2)Workspace is clean !$(tput sgr 0)"
else
    printResumeLine "Total" "$totalFilesCount" "" 10
    printResumeLine "Added" "$addedFilesCount" "valid" 10
    printResumeLine "Modified" "$modifiedFilesCount" "nc" 10
    printResumeLine "Deleted" "$deletedFilesCount" "error" 10
    printResumeLine "Merged" "$mergedFilesCount" "" 10
fi
printEnd