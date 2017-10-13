#!/bin/bash

path="$(pwd)"
for D in `find . -maxdepth 1 -type d`
do
	test="$(echo $D | grep -E '(module|composants)\-applicatif' -c)"
	if [ $test -eq 1 ]
	then
        echo ""
		echo -n "$(tput setaf 2)$(echo $D | grep -Eo "(H[0-9]{2}\-)?[a-zA-Z]*$")$(tput sgr 0) : "
		dirPath="$path$(echo $D | sed 's/^.//')"
		cd $dirPath
		res="$(grep -E "<version>.*</version>" pom.xml -m 2 | tail -1)"
		res=${res:11}
		res="$(echo $res | sed 's/.\{10\}$//')"
		# Printing POM composant version
		echo $res | grep --color -E "[0-9]{2,3}\-.*"
		if [ "$1" == "--full" ] || [ "$1" == "-f" ] ;
		then
		    res="$(awk '/<properties>/,/<\/properties>/' pom.xml | grep -Eo '(composant\-applicatif|module)+\-[a-zA-Z0-9]+.*>0[0-9]{1}_[0-9]{2}_[0-9]{2}\.[0-9]{2,3}(\-SNAPSHOT){0,1}' pom.xml | sed 's/.adb.version>/ /g ' | sort  | sed 's/composant-applicatif-/ ├──/g ')"
		    if [ $(echo "$res" | sed '/^\s*$/d' | wc -l) -gt 0 ] ;
		    then
		        echo "$res" | grep --color -E '[0-9]{2,3}(\-.*|$)'
		        echo " └─────────────────────────────────────────────"
		    fi
		elif [ "$1" == "--sync" ] || [ "$1" == "-s" ] ;
		then
            echo $res
		fi
		cd ../
	fi
done

