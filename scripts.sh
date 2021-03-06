#!/bin/bash

# Getting paths and other configuration variables

source $ROOT_PATH/configuration.sh

echo
echo "...$(tput setaf 3)WSP$(tput sgr 0) : '$(echo $WSP_PATH | grep -E '/[a-zA-Z0-9_-]+(/)?$' --color=always)'"
echo "$(tput setaf 3)Exlude$(tput sgr 0) : '$(echo $EXCLUDE_GROUP_FILE | grep -E '/[\.a-zA-Z0-9_-]+(/)?$' --color=always)'"

if [ $# -gt 0 ]
then
    if [ "$1" == "update" ] ;
    then
        $ROOT_PATH/install.sh -u
    elif [ "$1" == "status" ] || [ "$1" == "gst" ] ;
    then
        $SCRIPTS_PATH/status.sh $2 $3 $4 $5 $6
    elif [ "$1" == "stats" ] || [ "$1" == "sta" ] ;
    then
        $SCRIPTS_PATH/stats.sh $2 $3 $4 $5 $6
    elif [ "$1" == "clone" ] || [ "$1" == "gcl" ] ;
    then
        $SCRIPTS_PATH/clone.sh $2 $3 $4 $5 $6
    elif [ "$1" == "pull" ] || [ "$1" == "gpl" ] ;
    then
        $SCRIPTS_PATH/pull.sh $2 $3 $4 $5 $6
    elif [ "$1" == "command" ] || [ "$1" == "cmd" ] ;
    then
        $SCRIPTS_PATH/command.sh "$2" "$3" "$4" "$5" "$6"
    elif [ "$1" == "userId" ] || [ "$1" == "uid" ] ;
    then
        $SCRIPTS_PATH/uid.sh $2 $3 $4 $5 $6
    elif [ "$1" == "clean" ] || [ "$1" == "cl" ] ;
    then
        $SCRIPTS_PATH/clean.sh $2 $3 $4 $5 $6
    elif [ "$1" == "grunt" ] || [ "$1" == "grt" ] ;
    then
        $SCRIPTS_PATH/grunt.sh $2 $3 $4 $5 $6
    elif [ "$1" == "npm" ] || [ "$1" == "np" ] ;
    then
        $SCRIPTS_PATH/npm.sh $2 $3 $4 $5 $6
    elif [ "$1" == "pom" ] || [ "$1" == "po" ] ;
    then
        $SCRIPTS_PATH/pom.sh $2 $3 $4 $5 $6
    elif [ "$1" == "grep" ] || [ "$1" == "grp" ] ;
    then
        $SCRIPTS_PATH/grep.sh $2 $3 $4 $5 $6
    elif [ "$1" == "framework" ] || [ "$1" == "fw" ] ;
    then
        $SCRIPTS_PATH/framework.sh $2 $3 $4 $5 $6
    elif [ "$1" == "urls" ] || [ "$1" == "ur" ] ;
    then
        $SCRIPTS_PATH/urls.sh $2 $3 $4 $5 $6
    elif [ "$1" == "merge" ] || [ "$1" == "gbm" ] ;
    then
        $SCRIPTS_PATH/merge.sh $2 $3 $4 $5 $6
    elif [ "$1" == "branch" ] || [ "$1" == "gbr" ] ;
    then
        $SCRIPTS_PATH/branch.sh $2 $3 $4 $5 $6
    elif [ "$1" == "logs" ] || [ "$1" == "lo" ] ;
    then
        $SCRIPTS_PATH/log.sh $2 $3 $4 $5 $6
    elif [ "$1" == "workspace" ] || [ "$1" == "wsp" ] ;
    then
        $SCRIPTS_PATH/workspace.sh $2 $3 $4 $5 $6
    elif [ "$1" == "--help" ] || [ "$1" == "-h" ] ;
    then
        $SCRIPTS_PATH/../fullHelp.sh $2 $3 $4 $5 $6
    elif [ "$1" == "--open" ] || [ "$1" == "-o" ] ;
    then
        start "$ROOT_PATH/"
    else
        echo
        echo "$(tput setaf 1)Invalid arguments sent : $1$(tput sgr 0)"
    fi
else
    echo "$(tput setaf 1)No arguments sent.$(tput sgr 0)"
    echo "You have to specify a program name."
    echo "For a complete list of available commands, please add -h or --help."
fi