#!/bin/bash


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
echo "Plus d'informations dans chaque script ou $(tput setaf 3)en éxécutant un script avec l'argument --help $(tput sgr 0)(pas de -h car conflit)"
echo "Pour faire remonter des bugs ou si vous imaginez des améliorations ou ajouts, envoyez un mail à 'florian.castera@accenture.com'. Merci"
echo
echo "AVAILABLE COMMANDS :"
echo

. $ROOT_PATH/functions.sh

if [ -n "$1" ] ;
then
    scriptList=`find $SCRIPTS_PATH -maxdepth 1 -type f | grep "$1"`
else
    scriptList=`find $SCRIPTS_PATH -maxdepth 1 -type f`
fi

for scr in $scriptList
do
    scriptInfo=`awk '/################################B/,/################################E/' $scr | sed 's/# //g' | sed -e 's/^#.*//g' | sed '/^\s*$/d' `
    scriptName=`echo "$scriptInfo" | head -n 1`
    scriptCall=`echo "$scriptInfo" | head -n 2 | tail -n 1`
    scriptDesc=`echo "$scriptInfo" | head -n 3 | tail -n 1`
    scriptArgs=`echo "$scriptInfo" | grep -E '(\-\-[a-zA-Z]+/\-[a-zA-Z]{1}|Pas.*)' --color=always`

    echo "Name : $(tput setaf 2)$scriptName$(tput sgr 0)" | grep --color -E "^[a-zA-Z]+"
    echo "$scriptCall" | sed 's/:/: lbp/g' | grep --color -E "^[a-zA-Z]+"
    echo "$scriptDesc" | grep --color -E "^[a-zA-Z]+"
    echo "Arguments : "  | grep --color -E "^[a-zA-Z]+"
    echo "$scriptArgs"
    echo
    echo "-----------------------------------------------------------------"
done