#!/bin/bash

tasks=$@

echo
echo "$(tput setaf 2)Executing grunt tasks for all projects...$(tput sgr 0)"
echo "─┬────────────────────────────"
echo " │"
echo " ╞──Tasks : '$(tput setaf 2)$tasks$(tput sgr 0)'"
echo " ╞──Output will be fully printed"
echo " │"

totalErrors=0
totalIgnored=0
totalSuccess=0

# Looping over directories in Workspace path
for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
    cd $projectPath
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
    echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
    npm $task
    echo
done

echo " │"
echo "─╪────────────────────────────"
