#!/bin/bash

path="$(pwd)"
pullArgs="$@"

successFilesCount=0
uptodateFilesCount=0
errorsFilesCount=0
mergedFilesCount=0

echo
echo "$(tput setaf 2)Pulling repositories from remote...$(tput sgr 0)"
echo "─┬─────────────────────────────────"
echo " │"
echo " ╞──Arguments : '$(tput setaf 2)$pullArgs$(tput sgr 0)'"
echo " │"
# Looping over directories in Workspace path
for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
    # Testing if directory pattern matches watched directories
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    # Going into project folder to execute Git commands
    cd $projectPath

    # Preparing results storage
    resultStash=""
    resultPull=""
    resultPop=""
    isStashed="false"
    state=""

    if [ `echo "$@" | grep -Eci "(--stash)+"` -gt 0 ] ;
    then
        # Stashing local changes
        resultStash=`git stash 2>&1`
        isStashed="true"
        pullArgs=`echo "$pullArgs" | sed 's/--stash//g'`
        if [ `echo "$resultStash" | grep -Eci "no local changes to save"` -gt 0 ] ;
        then
            isStashed="false"
        elif [ `echo "$resultStash" | grep -Eci "(fatal|error)+"` -gt 0 ] ;
        then
		    let "mergedFilesCount = $mergedFilesCount + 1"
            isStashed="false"
            echo "[$(tput setaf 1)X$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
            echo " ╞───Unable to stash local changes because of unmerged files !"
            echo " ╞───Aborting pull for this project !"
            echo " ╞───Files :"
            echo "$resultStash" | grep -Eoi "^.*needs merge.*$" | sed -E "s/^(\s|\t)*/ ╞─────/g" | sed -E '/^\s*$/d'
            echo " │"
            continue
        fi
    fi

    if [ `echo "$@" | grep -Eci "(--force)+"` -gt 0 ] ;
    then
        # Preparing pull arguments
        pullArgs=`echo "$pullArgs" | sed 's/--force//g'`
        pullArgs="$pullArgs -X theirs"
    fi

    # Do the pull
    resultPull=`git pull $pullArgs 2>&1`

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
        echo "[$(tput setaf 1)X$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
        if [ "$isStashed" == "true" ] ;
        then
            echo " ╞───Local changes stashed !"
        fi
        echo " ╞───Error ! Files would be overwritten !"
        echo " ╞───Files :"
        files=`echo "$resultPull" | grep -Eio "(\s|\t)*[a-zA-Z]*\/.*\/.*" | sed -E "s/^(\s|\t)*/ ╞─────/g" | sed -E '/^\s*$/d'`
        echo "$(tput setaf 1)$files $(tput sgr 0)"
        if [ "$isStashed" == "true" ] ;
        then
            echo " ╞───Local changes unstashed !"
        fi
    elif [ `echo "$resultPull" | grep -ic "already up-to-date"` -gt 0 ] ;
    then
		let "uptodateFilesCount = $uptodateFilesCount + 1"
        # Overwrite warning
        echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
        if [ "$isStashed" == "true" ] ;
        then
            echo " ╞───Local changes stashed !"
        fi
        echo " ╞───Already up-to-date !"
        if [ "$isStashed" == "true" ] ;
        then
            echo " ╞───Local changes unstashed !"
        fi
    else
		let "successFilesCount = $successFilesCount + 1"
        echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
        if [ "$isStashed" == "true" ] ;
        then
            echo " ╞───Local changes stashed !"
        fi
        echo " ╞───Project updated and correctly merged !"
        if [ "$isStashed" == "true" ] ;
        then
            echo " ╞───Local changes unstashed !"
        fi
    fi
    echo " │"
done

echo " │"
echo "─╪────────────────────────────"
echo " ╞─ $(tput setaf 2)Success$(tput sgr 0)     : $successFilesCount"
echo " ╞─ $(tput setaf 2)Up-to-date$(tput sgr 0)  : $uptodateFilesCount"
echo " ╞─ $(tput setaf 3)Merging$(tput sgr 0)     : $mergedFilesCount"
echo " ╞─ $(tput setaf 1)Errors$(tput sgr 0)      : $errorsFilesCount"

if [ $mergedFilesCount -gt 0 ] ;
then
    echo " │"
    read -p " ╞─ There is some unmerged files... Merge them ? (y/n) " merging
    if [ "$merging" == "y" ] ;
    then
        for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
        do
            projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
            cd $projectPath
            resultMerge=`git mergetool 2>&1`
            echo "$resultMerge" | sed -E "s/^(\s|\t)*/ ╞───/g" | sed -E '/^\s*$/d'
        done
    fi
    echo " │"
fi
echo " ╘────────────────────────────"