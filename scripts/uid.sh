#!/bin/bash

path="$(pwd)"
modifiedFilesCount=0
ignoredFilesCount=0
errorsFilesCount=0
file=""
userId="$1"

echo
echo "$(tput setaf 2)Setting UserId for projects...$(tput sgr 0)"
echo "─┬────────────────────────────"
echo " │"
echo " ╞──New userId : '$(tput setaf 2)$userId$(tput sgr 0)'"
echo " │"
# Looping over directories in Workspace path
for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
    cd $projectPath # Going into project folder to execute commands
    projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    files=`find $projectPath -name "SecurityBouchonConfig.xml"`

    if [ "$files" != "" ] ;
    then
        echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"

        for file in $files
        do
            # File exists
            sed -i -e "s@<property name=\"userId\" value=\".*\"[ ]*\\/>@<property name=\"userId\" value=\"$userId\" \\/>@g" $file
            result=`grep -Ec "<property name=\"userId\" value=\"$userId\"(\s)*/>" $file`
            minFile=`echo "$file" | sed -e "s@$projectPath@@g"`

            if [ $result -gt 0 ] ;
            then
                echo " ╞───UserId successfully changed in $minFile"
		        let "modifiedFilesCount = $modifiedFilesCount + 1"
            else
                echo " $(tput setaf 3)╞───Unable to change userId in $minFile !$(tput sgr 0)"
		        let "ignoredFilesCount = $ignoredFilesCount + 1"
            fi
        done
        echo " │"
    else
        let "errorsFilesCount = $errorsFilesCount + 1"
        echo "[$(tput setaf 1)X$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
        echo " ╞───Pas de fichier 'SecurityBouchonConfig.xml' !"
        echo " │"
    fi
done

echo "─╪────────────────────────────"
echo " ╞─ $(tput setaf 2)Modified$(tput sgr 0) : $modifiedFilesCount"
echo " ╞─ $(tput setaf 1)Errors$(tput sgr 0) : $errorsFilesCount"
echo " ╞─ $(tput setaf 3)Ignored$(tput sgr 0) : $ignoredFilesCount"
echo " ╘────────────────────────────"