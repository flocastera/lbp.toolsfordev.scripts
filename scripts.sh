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
    elif [ "$1" == "grep" ] || [ "$1" == "grp" ] ;
    then
        if [ "$2" == "--count" ] || [ "$2" == "-c" ] ;
        then
            $SCRIPTS_PATH/grep.sh --count $3 $4 $5 $6
        elif [ "$2" == "--count-only" ] || [ "$2" == "-co" ] ;
        then
            $SCRIPTS_PATH/grep.sh --count-only $3 $4 $5 $6
        else
            $SCRIPTS_PATH/grep.sh --matches $2 $3 $4 $5 $6
        fi
    elif [ "$1" == "--help" ] || [ "$1" == "-h" ] ;
    then
        echo
        echo "$(tput setaf 2)#########################"
        echo "#                       #"
        echo "#  $(tput sgr 0)lbp script launcher$(tput setaf 2)  #"
        echo "#                       #"
        echo "#  $(tput setaf 1)Breakfast use fee  $(tput setaf 2)  #"
        echo "#  $(tput setaf 1)Contact FCA for    $(tput setaf 2)  #"
        echo "#  $(tput setaf 1)  more commands    $(tput setaf 2)  #"
        echo "#                       #"
        echo "#########################$(tput sgr 0)"
        echo
        echo "Usage : lbp commandName [arg1] [arg2] ... [argN]"
        echo
        echo "AVAILABLE COMMANDS :"
        echo "$(tput setaf 3)GIT :$(tput sgr 0)"
        echo " - $(tput setaf 2)clone$(tput sgr 0)/gcl    => clone every repositories from configuration file (-f)"
        echo " - $(tput setaf 2)status$(tput sgr 0)/gst   => show Git status for all components/modules (-h/-u/-b)"
        echo " - $(tput setaf 2)pull$(tput sgr 0)/gpl     => do a Git pull for all components/modules (-s/-d)"
        echo "$(tput setaf 3)OTHER :$(tput sgr 0)"
        echo " - $(tput setaf 2)command$(tput sgr 0)/cmd  => show pom version for all components/modules"
        echo " - $(tput setaf 2)pom$(tput sgr 0)/po       => show pom version for all components/modules (-f/-s)"
        echo " - $(tput setaf 2)framework$(tput sgr 0)/fw => show frameworks versions for all components/modules (-s)"
        echo " - $(tput setaf 2)grep$(tput sgr 0)/grp     => execute grep commmands in all project (-c/-co)"
        echo " - $(tput setaf 2)npm$(tput sgr 0)/np       => execute grunt tasks given in parameters"
        echo " - $(tput setaf 2)grunt$(tput sgr 0)/grt    => execute grunt tasks given in parameters (-d/-a)"
        echo " - $(tput setaf 2)userId$(tput sgr 0)/uid   => modify userId in SecurityBouchonConfig.xml (-l)"
        echo " - $(tput setaf 2)clean$(tput sgr 0)/cl     => clean projects files (.bak, .log, ...) (-d)"
        echo
        echo "Plus d'informations dans chaque script ou $(tput setaf 3)en éxécutant un script avec l'argument --help $(tput sgr 0)(pas de -h car conflit)"
    else
        echo
        echo "$(tput setaf 1)Invalid arguments sent : $1$(tput sgr 0)"
    fi
else
    echo "$(tput setaf 1)No arguments sent.$(tput sgr 0)"
    echo "You have to specify a program name."
    echo "For a complete list of available commands, please add -h or --help."
fi
