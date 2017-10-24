#!/bin/bash

path="$(pwd)"
totalFilesCount=0
modifiedFilesCount=0
addedFilesCount=0
deletedFilesCount=0
mergedFilesCount=0

echo
echo "$(tput setaf 2)Getting status for projects...$(tput sgr 0)"

for projectPath in `find $WSP_PATH -maxdepth 1 -type d`
do
    test=`echo $projectPath | grep -E "$watchPatterns" -c`
	if [ "$test" == "1" ] ;
	then
		cd $projectPath

		result=`git status -s`
        resultModified=`echo "$result" | grep -E "^(\s)?M.*"`
        resultAdded=`echo "$result" | grep -E "^(\s)?A.*"`
        resultDeleted=`echo "$result" | grep -E "^(\s)?D.*"`
        resultUnknown=`echo "$result" | grep -E "^(\s)?\?.*"`
		total=$(echo "$result" | sed '/^\s*$/d' | wc -l)

		if [ "$1" == "-h" ] ;
		then
		    result=`echo "$result" | grep -Ev "AccreditationService|pom\.xml|\.properties|SecurityBouchonConfig|\.classpath|\.settings|\.gitignore"`
            resultModified=`echo "$result" | grep -E "^(\s)?M.*"`
            resultAdded=`echo "$result" | grep -E "^(\s)?A.*"`
            resultDeleted=`echo "$result" | grep -E "^(\s)?D.*"`
            resultUnknown=`echo "$result" | grep -E "^(\s)?\?.*"`
		    total=$(echo "$result" | sed '/^\s*$/d' | wc -l)
		fi

		if [ "$total" != "0" ] ;
		then
            echo
            echo "$(echo $projectPath | grep -Eo "(H[0-9]{2}\-)?[a-zA-Z]*$")"

		    let "totalFilesCount = $totalFilesCount + $total"

            if [ "$resultAdded" != "" ] ;
            then
                echo "$(tput setaf 2)$resultAdded$(tput sgr 0)"
		        let "addedFilesCount = $addedFilesCount + `echo "$resultAdded" | wc -l`"
            fi

            if [ "$resultModified" != "" ] ;
            then
                added=`echo "$resultModified" | grep -E "^M.*"`
                notAdded=`echo "$resultModified" | grep -E "^\sM.*"`

		        let "modifiedFilesCount = $modifiedFilesCount + `echo "$resultModified" | wc -l`"

                if [ "$added" != "" ] ;
                then
                    echo "$(tput setaf 2)$added$(tput sgr 0)"
                fi
                if [ "$notAdded" != "" ] ;
                then
                    echo "$(tput setaf 1)$notAdded$(tput sgr 0)"
                fi
            fi

            if [ "$resultDeleted" != "" ] ;
            then
                echo "$(tput setaf 2)$resultDeleted$(tput sgr 0)"
		        let "deletedFilesCount = $deletedFilesCount + `echo "$resultDeleted" | wc -l`"
            fi

            if [ "$resultUnknown" != "" ] ;
            then
                echo "$(tput setaf 3)$resultUnknown$(tput sgr 0)"
		        let "mergedFilesCount = $mergedFilesCount + `echo "$resultUnknown" | wc -l`"
            fi
		else
            echo "No changes in $(echo $projectPath | grep -Eo "(H[0-9]{2}\-)?[a-zA-Z]*$")"
		fi
	fi
done

echo -e "──┬┬───────────────────────────────────────"
echo "  ||"
if [ "$totalFilesCount" == "0" ] ;
then
    echo "  ╘╧════> $(tput setaf 2)Workspace is clean !$(tput sgr 0)"
else
    echo "  │╞════> $(tput setaf 2)Total$(tput sgr 0)    : $totalFilesCount"
    echo "  │╞════> $(tput setaf 3)Added$(tput sgr 0)    : $addedFilesCount"
    echo "  │╞════> $(tput setaf 3)Modified$(tput sgr 0) : $modifiedFilesCount"
    echo "  │╞════> $(tput setaf 3)Deleted$(tput sgr 0)  : $deletedFilesCount"
    echo "  ╘╧════> $(tput setaf 3)Merged$(tput sgr 0)   : $mergedFilesCount"
fi