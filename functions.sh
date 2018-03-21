#!/bin/bash


hasArgument(){
	searches=`echo "$2" | tr ';' '\n'`
	retour=0

	longArgs=`echo "$1" | grep -Eo "\-\-[a-zA-Z0-9=\-]+" | grep -Eo "[a-z]{1}[a-zA-Z0-9=\-]+" | sed '/^\s*$/d'`
	shortArgs=`echo "$1" | grep -Eo "(^|\s)\-[a-zA-Z]+" | grep -Eo "[a-zA-Z]{1}" | sed '/^\s*$/d'`

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

isExcluded(){
    retour=0
    hasFile=`ls -la $WSP_PATH | grep '.lbpexclude' -c`
    if [ $hasFile -gt 0 ] ;
    then
        result=`cat $WSP_PATH/.lbpexlcude | grep "$1" -c`
        if [ $result -gt 0 ] ;
        then
            retour=1
        fi
    fi
    return $retour
}

printHelp() {
    prargsIn=$1
    prtitle=$2
    prdesc=$3
    prappels=$4
    prargs=";$5"
    prexemple=";$6"

    hasArgument "$prargsIn" "help"
    if [ $? -eq 1 ] ;
    then
        prargs=`echo "$prargs" | sed 's/;/\\n\\t/g' | sed 's/=/ : /g'`
        prexemple=`echo "$prexemple" | sed 's/;/\\n\\t/g' | sed 's/=/ : /g'`

        echo
        echo "##########[HELP]##########"
        echo
        echo "Script      : $(tput setaf 2)$prtitle$(tput sgr 0)"
        echo "Description : $prdesc"
        echo "Appel       : $prappels"
        echo "Arguments   : $prargs"
        echo "Exemple     : $prexemple"
        echo
        echo "##########################"

        exit
    fi
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
    info="$3 $4 $5"

    if [ "$state" == "valid" ] ;
    then
        state="$(tput setaf 2)V$(tput sgr 0)"
    elif [ "$state" == "error" ] ;
    then
        state="$(tput setaf 1)X$(tput sgr 0)"
    elif [ "$state" == "nc" ] ;
    then
        state="$(tput setaf 3)O$(tput sgr 0)"
    else
        state=" "
    fi

    str="[$state]──$(tput setaf 2)$project$(tput sgr 0)"

    if [ -n "$info" ]  ;
    then
        str="$str : $info"
    fi
    echo $str
}

printProjectInfoTemp(){
    project=$1
    state=$2
    info="$3 $4 $5"

    if [ "$state" == "valid" ] ;
    then
        state="$(tput setaf 2)V$(tput sgr 0)"
    elif [ "$state" == "error" ] ;
    then
        state="$(tput setaf 1)X$(tput sgr 0)"
    elif [ "$state" == "nc" ] ;
    then
        state="$(tput setaf 3)O$(tput sgr 0)"
    else
        state=" "
    fi

    str="[$state]──$(tput setaf 2)$project$(tput sgr 0)"

    if [ -n "$info" ]  ;
    then
        str="$str : $info"
    fi
    echo -ne "$str\r"
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
    else
        str=" ╞───"
    fi

    echo "$str$1"
}

printResumeStart(){
    echo  "─╪─────────────────────────────────────────────"
}

printResumeLine(){
    libelle=$1
    value=$2
    state=$3
    tab=$4
    str=""
    if [ "$state" == "valid" ] ;
    then
        str=" $(tput setaf 2)╞──$libelle$(tput sgr 0)"
    elif [ "$state" == "error" ] ;
    then
        str=" $(tput setaf 1)╞──$libelle$(tput sgr 0)"
    elif [ "$state" == "nc" ] ;
    then
        str=" $(tput setaf 3)╞──$libelle$(tput sgr 0)"
    else
        str=" ╞──$libelle"
    fi

    if [ -n "$tab" ] ;
    then
        sizeLibelle=${#libelle}
        let tab=$tab-$sizeLibelle

        for (( c=0; c<$tab; c++ ))
        do
            str="$str "
        done
    else
        str="$str "
    fi

    if [ -n "$libelle" ] ;
    then
        str="$str: $value"
    else
        str=" │"
    fi

    echo "$str"
}