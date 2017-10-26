#!/bin/bash

path="$(pwd)"
totalFilesCount=0
modifiedFilesCount=0
addedFilesCount=0
deletedFilesCount=0
mergedFilesCount=0

echo
echo "$(tput setaf 2)Getting status for projects...$(tput sgr 0)"
echo "─┬────────────────────────────"
echo " │"
# Looping over directories in Workspace path
for projectPath in `find $WSP_PATH -maxdepth 1 -type d`
do
    # Testing if directory pattern matches watched directories
    test=`echo $projectPath | grep -E "$watchPatterns" -c`
	if [ "$test" == "1" ] ;
	then
		cd $projectPath # Going into project folder to execute Git commands

		result=`git status -s` # Getting general status for project
        resultModified=`echo "$result" | grep -E "^(\s)?M.*"`   # Getting modified files
        resultAdded=`echo "$result" | grep -E "^(\s)?A.*"`      # Getting added files
        resultDeleted=`echo "$result" | grep -E "^(\s)?D.*"`    # Getting deleted files
        resultUnknown=`echo "$result" | grep -E "^(\s)?\?.*"`   # Getting merged/merging files
		total=$(echo "$result" | sed '/^\s*$/d' | wc -l)        # Calculating total

		if [ "$1" == "-h" ] ;
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
            echo "[$(tput setaf 1)x$(tput sgr 0)]──$(echo $projectPath | grep -Eo "$projectNamePatterns")"

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
            echo " │"
		else
		    # Displaying message if nothing change in folder (supports excluded files)
            echo "[$(tput setaf 2)V$(tput sgr 0)]──No changes in $(echo $projectPath | grep -Eo "(H[0-9]{2}\-)?[a-zA-Z]*$")"
            echo " │" 
		fi
	fi
done

echo " │"
echo -e "─╪────────────────────────────"
if [ "$totalFilesCount" == "0" ] ;
then
    echo " ╘─ $(tput setaf 2)Workspace is clean !$(tput sgr 0)"
else
    echo " ╞─ $(tput setaf 2)Total$(tput sgr 0)    : $totalFilesCount"
    echo " ╞─ $(tput setaf 3)Added$(tput sgr 0)    : $addedFilesCount"
    echo " ╞─ $(tput setaf 3)Modified$(tput sgr 0) : $modifiedFilesCount"
    echo " ╞─ $(tput setaf 1)Deleted$(tput sgr 0)  : $deletedFilesCount"
    echo " ╞─ Merged   : $mergedFilesCount"
    echo -e " ╘────────────────────────────"
fi