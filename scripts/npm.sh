#!/bin/bash

################################B
# npm.sh
# Appel : npm/np
# Description : Permet d'exécuter des tâches npm dans tous les projets
# Args :
#   --detail/-d : Affiche la sortie de NPM
################################E

. $ROOT_PATH/functions.sh
args=`echo "$@" | grep -E -o "\-{1,2}[^($| )]+"`
tasks=`echo "$@" | grep -E -o "(^| )+[a-zA-Z]+"`

printHelp "$args" "npm.sh" "Exécute les tâches node passées en paramètres" "npm/np" "--detail/-d=Affiche la sortie de NPM" "lbp npm install --save-dev"

printTitle "Executing npm tasks for all projects"
printInfo "Arguments : '$args'"
printInfo "Tasks : '$(tput setaf 2)$tasks$(tput sgr 0)'"
printInfo "Output will be fully printed"
printLine

totalErrors=0
totalIgnored=0
totalSuccess=0

# Looping over directories in Workspace path
patterns=`cat $ROOT_PATH/.lbpexclude`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

for projectPath in $loops
do
    cd $projectPath
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
    printProjectInfoTemp "$projectName" "nc"
    result=`npm $task`

    printProjectInfo "$projectName" "valid"

    hasArgument "$args" "detail;d"
    if [ $? -eq 1 ] ;
    then
        echo "$result" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
    fi

    printLine
done

printEnd
