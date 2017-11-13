#!/bin/bash

args=$@

echo
echo "$(tput setaf 2)Executing commands in all projects...$(tput sgr 0)"
echo "─┬───────────────────────────────────"
echo " │"
echo " ╞──Arguments : '$(tput setaf 2)$args$(tput sgr 0)'"
echo " │"

totalErrors=0
totalIgnored=0
totalSuccess=0

# Looping over directories in Workspace path
for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
    # Testing if directory pattern matches watched directories
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    cd $projectPath # Going into project folder to execute grunt commands

    resp=`$args` # Executing grunt tasks
    echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
    echo " │"
        echo "$resp" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
    echo " │"

done

echo "─╪───────────────────────────────────"