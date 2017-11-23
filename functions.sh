#!/bin/bash


hasArgument(){
	searches=`echo "$2" | tr ';' '\n'`
	retour=0

	longArgs=`echo "$1" | grep -Eo "\-\-[a-zA-Z0-9=]+" | grep -Eo "[a-zA-Z0-9=]+" | sed '/^\s*$/d'`
	shortArgs=`echo "$1" | grep -Eo "(^|\s)\-[a-zA-Z]+" | grep -Eo [a-zA-Z]{1} | sed '/^\s*$/d'`

	for search in $searches
	do
		resultLong=`echo "$longArgs" | grep -E "^$search$" -c`
		resultShort=`echo "$shortArgs" | grep -E "^$search$" -c`

		if [ $resultLong -gt 0 ] || [ $resultShort -gt 0 ] ;
		then
			retour=1
		fi
	done
	return $retour
}

printTitle(){
    title=$1
    size=${#title}
    let size=$size+1

    str="─┬"
    for (( c=0; c<$size; c++ ))
    do
	str="$str─"
    done
    echo
    echo "$(tput setaf 2)$title...$(tput sgr 0)"
    echo $str
}

printInfo(){
    echo " ╞──"$1
}

printLine(){
    echo " │"
}

printEnd(){
    echo " ╘─────────────────────────────────────────────"
}

printProjectInfo(){
    project=$1
    state=$2
    info=$3

    if [ "$state" == "valid" ] ;
    then
        state="$(tput setaf 2)V$(tput sgr 0)"
    elif [ "$state" == "error" ] ;
    then
        state="$(tput setaf 1)X$(tput sgr 0)"
    elif [ "$state" == "nc" ] ;
    then
        state="$(tput setaf 3)O$(tput sgr 0)"
    fi

    str="[$state]──$(tput setaf 2)$project$(tput sgr 0)"

    if [ -n "$info" ]  ;
    then
        str="$str : $info"
    fi
    echo $str
}

printProjectLine(){
    state=$2
    str=""
    if [ "$state" == "valid" ] ;
    then
        str=" $(tput setaf 2)╞───$(tput sgr 0)"
    elif [ "$state" == "error" ] ;
    then
        str=" $(tput setaf 1)╞───$(tput sgr 0)"
    elif [ "$state" == "nc" ] ;
    then
        str=" $(tput setaf 3)╞───$(tput sgr 0)"
    fi

    echo "$str$1"
}