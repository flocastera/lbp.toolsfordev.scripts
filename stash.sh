#!/bin/bash

path="$(pwd)"
echo
for D in `find . -maxdepth 1 -type d`
do
	test="$(echo $D | grep -E '(module|composants)\-applicatif' -c)"
	if [ $test -eq 1  ]; 
	then
		echo "Status for $(tput setaf 2)$(echo $D | grep -Eo "[a-zA-Z]*$")$(tput sgr 0)"
		dirPath="$path$(echo $D | sed 's/^.//')"
		cd $dirPath
		if [ "$1" == "st" ]
		then
			git stash
		elif [ "$1" == "pop" ]
		then
			git stash pop
		fi
		cd ../
		echo 
	fi
done
