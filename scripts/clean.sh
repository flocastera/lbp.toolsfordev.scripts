#!/bin/bash

################################B
# clean.sh
# Appel : clean/cl
# Description : Permet de nettoyer le projet des fichiers résiduels (*.bak, *.log, *.orig, ...)
# Args :
#   --detail/-d : Affiche tous les fichiers supprimés de façon exhaustive
################################E

. $ROOT_PATH/functions.sh
path="$(pwd)"
args=$@

printHelp  "$args" "clean.sh" "Nettoie les projets des fichiers résiduels (.bak, .orig, ...)" "clean/cl" "--detail/-d=Liste les fichiers supprimés" "lbp clean -d"

filesToDelete="(*\.log$|*\.bak$|*\.orig$|*\.xmle)+"
exludedPaths="(*\.git|*node_modules*)"

totalDeleted=0

printTitle "Cleaning all projects"
printInfo "Files to delete : '$(tput setaf 2)$filesToDelete$(tput sgr 0)'"
printInfo "Excluded paths : '$(tput setaf 2)$exludedPaths$(tput sgr 0)'"
printLine

patterns=`cat $EXCLUDE_GROUP_FILE`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

for projectPath in $loops
do
    cd $projectPath
    projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    printProjectInfoTemp "$projectName" "nc"

    result=`find $projectPath | grep -Ev "$exludedPaths" | grep -E "$filesToDelete"`
    count=`echo "$result" | sed '/^\s*$/d' | wc -l`

    let "totalDeleted = $totalDeleted + $count"

    if [ $count -gt 0 ] ;
    then
        printProjectInfo "$projectName" "valid"

        for file in `echo "$result"`
        do
            rm -f $file 2> /dev/null
        done

        hasArgument "$args" "detail;d"
        if [ $? -eq 1 ] ;
        then
            printProjectLine "Those files ($(tput setaf 2)$count$(tput sgr 0)) will be removed :"
            echo "`echo "$result" | sed "s@$projectPath@@g" | sed "s/^/ ╞────/g "`"
        else
            printProjectLine "$count files will be removed !"
        fi
    else
        printProjectInfo "$projectName" "error"
        printProjectLine "Project is already clean !"
    fi
    printLine
done

printResumeStart
echo " ╞─ Files deleted : $(tput setaf 2)$totalDeleted$(tput sgr 0)"
printEnd