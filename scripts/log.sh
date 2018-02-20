#!/bin/bash

################################B
# log.sh
# Appel : logs/lo
# Description : Permet de modifier les niveaux de logs pour les frameworks
# Args :
#   Pas d'arguments
################################E

. $ROOT_PATH/functions.sh
args=$@

printHelp "$args" "log.sh" "Permet de modifier les niveaux de logs pour les frameworks" "Pas d'arguments" "lbp log info"

level=""

if [ "$args" == "debug" ] ;
then
    level="DEBUG"
elif [ "$args" == "info" ] ;
then
    level="INFO"
else
    printTitle "Argument is not correct"
    exit
fi

printTitle "Changing logs level in all projects' GCP"
printInfo "Arguments : '$(tput setaf 2)$args$(tput sgr 0)'"
printLine


patterns=`cat $ROOT_PATH/.lbpexclude`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

for projectPath in $loops
do
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    cd $projectPath

    if [ -f "$projectPath/src/main/resources/log4j.properties" ]; then
        sed -i -r "s@^log4j\.category\.fr\.laposte\.disf\.fwmc\.internal\.arch\.isolation\.nosql=[A-Z]+@log4j\.category\.fr\.laposte\.disf\.fwmc\.internal\.arch\.isolation\.nosql=${level}@g" $projectPath/src/main/resources/log4j.properties
        sed -i -r "s@^log4j\.category\.org\.springframework=[A-Z]+@log4j\.category\.org\.springframework=${level}@g" $projectPath/src/main/resources/log4j.properties
        sed -i -r "s@^log4j\.category\.fr\.laposte\.disf\.fwmc=[A-Z]+@log4j\.category\.fr\.laposte\.disf\.fwmc=${level}@g" $projectPath/src/main/resources/log4j.properties
        sed -i -r "s@^log4j\.category\.fr\.laposte\.disf\.fwmc\.arch\.rest\.canal\.routing=[A-Z]+@log4j\.category\.fr\.laposte\.disf\.fwmc\.arch\.rest\.canal\.routing=${level}@g" $projectPath/src/main/resources/log4j.properties

        printProjectInfo "$projectName" "valid" "Changed to $(tput setaf 3)$level$(tput sgr 0) log level"
    else
        printProjectInfo "$projectName" "error" "No log4j.properties file"
    fi
    printLine

done

printEnd