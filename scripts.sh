#!/bin/bash

# Getting paths and other configuration variables
source $WSP_PATH/lbp.toolsfordev.scripts/configuration.sh

if [ $# -gt 0 ]
then
    if [ "$1" == "status" ] || [ "$1" == "gst" ] ;
    then
        $SCRIPTS_PATH/status.sh $2 $3 $4 $5 $6
    elif [ "$1" == "clone" ] || [ "$1" == "gcl" ] ;
    then
        $SCRIPTS_PATH/clone.sh $2 $3 $4 $5 $6
    elif [ "$1" == "pull" ] || [ "$1" == "gpl" ] ;
    then
        $SCRIPTS_PATH/pull.sh $2 $3 $4 $5 $6
    elif [ "$1" == "command" ] || [ "$1" == "cmd" ] ;
    then
        $SCRIPTS_PATH/command.sh $2 $3 $4 $5 $6
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
    elif [ "$1" == "framework" ] || [ "$1" == "fw" ] ;
    then
        $SCRIPTS_PATH/framework.sh $2 $3 $4 $5 $6
    elif [ "$1" == "--help" ] || [ "$1" == "-h" ] ;
    then
        $SCRIPTS_PATH/../fullHelp.sh $2 $3 $4 $5 $6
    else
        echo
        echo "$(tput setaf 1)Invalid arguments sent : $1$(tput sgr 0)"
    fi
else
    echo "$(tput setaf 1)No arguments sent.$(tput sgr 0)"
    echo "You have to specify a program name."
    echo "For a complete list of available commands, please add -h or --help."
fi
