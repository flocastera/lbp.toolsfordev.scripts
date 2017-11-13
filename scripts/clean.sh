#!/bin/bash

filesToDelete="(*\.log$|*\.bak$|*\.orig$|*\.xmle)+"
exludedPaths="(*\.git|*node_modules*)"

totalDeleted=0

echo
echo "$(tput setaf 2)Cleaning all projects...$(tput sgr 0)"
echo "─┬─────────────────────────────────────────"
echo " │"
echo " ╞──Files to delete : '$(tput setaf 2)$filesToDelete$(tput sgr 0)'"
echo " ╞──Excluded paths : '$(tput setaf 2)$exludedPaths$(tput sgr 0)'"
echo " │"

for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
    cd $projectPath
    projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    result=`find $projectPath | grep -Ev "$exludedPaths" | grep -E "$filesToDelete"`
    count=`echo "$result" | sed '/^\s*$/d' | wc -l`

    let "totalDeleted = $totalDeleted + $count"

    if [ $count -gt 0 ] ;
    then
        echo "[$(tput setaf 3)O$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"

        for file in `echo "$result"`
        do
            rm -f $file 2> /dev/null
        done

        if [ "$1" == "--detail" ] || [ "$1" == "-d" ] ;
        then
            echo " ╞───Those files ($(tput setaf 2)$count$(tput sgr 0)) will be removed :"
            echo "`echo "$result" | sed "s@$projectPath@@g" | sed "s/^/ ╞────/g "`"
        else
            echo " ╞───$count files will be removed !"
        fi
    else
        echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
        echo " ╞───Project is clean !"
    fi
    echo " │"
done

echo "─╪───────────────────────────────"
echo " ╞─ Files deleted : $(tput setaf 2)$totalDeleted$(tput sgr 0)"
echo " ╘───────────────────────────────"