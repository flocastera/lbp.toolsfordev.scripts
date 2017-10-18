#!/bin/bash

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
    elif [ "$1" == "reset" ] || [ "$1" == "grs" ] ;
    then
        $SCRIPTS_PATH/reset.sh $2 $3 $4 $5 $6
    elif [ "$1" == "checkout" ] || [ "$1" == "gbr" ] ;
    then
        $SCRIPTS_PATH/checkout.sh $2 $3 $4 $5 $6
    elif [ "$1" == "stash" ] || [ "$1" == "gsta" ] ;
    then
        $SCRIPTS_PATH/stash.sh st $3 $4 $5 $6
    elif [ "$1" == "pop" ] || [ "$1" == "gstp" ] ;
    then
        $SCRIPTS_PATH/stash.sh pop $2 $3 $4 $5 $6
    elif [ "$1" == "state" ] || [ "$1" == "st" ] ;
    then
        $SCRIPTS_PATH/states.sh $2 $3 $4 $5 $6
    elif [ "$1" == "npm" ] || [ "$1" == "npm" ] ;
    then
        $SCRIPTS_PATH/npm.sh $2 $3 $4 $5 $6
    elif [ "$1" == "pom" ] || [ "$1" == "po" ] ;
    then
        $SCRIPTS_PATH/pom.sh $2 $3 $4 $5 $6
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
        echo " - $(tput setaf 2)clone/gcl$(tput sgr 0)    => clone every repositories inserted in repositories.txt"
        echo " - $(tput setaf 2)status/gst$(tput sgr 0)   => show Git status for all components/modules (with -s option)"
        echo " - $(tput setaf 2)pull/gpl$(tput sgr 0)     => do a Git pull for all components/modules"
        echo " - $(tput setaf 2)reset/grs$(tput sgr 0)    => do a Git reset for all components/modules (with --hard option)"
        echo " - $(tput setaf 2)checkout/gbr$(tput sgr 0) => do a Git checkout to specified branch for all components/modules"
        echo " - $(tput setaf 2)stash/gsta$(tput sgr 0)   => do a Git stash for all components/modules (can add 'pop')"
        echo " - $(tput setaf 2)pop/gstp$(tput sgr 0)     => do a Git stash pop for all components/modules (equivalent to 'gsta pop')"
        echo "$(tput setaf 3)OTHER :$(tput sgr 0)"
        echo " - $(tput setaf 2)state/st$(tput sgr 0)     => do a ping on specified IP, or service name (ex: couchbase)"
        echo " - $(tput setaf 2)pom$(tput sgr 0)          => show pom version for all components/modules (-f/--full to also print dependencies)"
        echo " - $(tput setaf 2)npm$(tput sgr 0)          => execute npm commands for all components"
    else
        echo
        echo "$(tput setaf 1)Invalid arguments sent : $1$(tput sgr 0)"
    fi
else
    echo "$(tput setaf 1)No arguments sent.$(tput sgr 0)"
    echo "You have to specify a program name."
    echo "For a complete list of available commands, please add -h or --help."
fi