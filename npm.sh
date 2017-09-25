#!/bin/bash

path="$(pwd)"
echo
for D in `find . -maxdepth 1 -type d`
do
	test="$(echo $D | grep -E '(composants)\-applicatif' -c)"
	if [ $test -eq 1  ]; 
	then
		echo "Executing npm with args : $(tput setaf 3)$1 $2 $3 $4$(tput sgr 0) in $(tput setaf 2)$(echo $D | grep -Eo "[a-zA-Z]*$")$(tput sgr 0)"
		dirPath="$path$(echo $D | sed 's/^.//')"
		cd $dirPath
		npm $1 $2 $3 $4
		cd ../
		echo 
	fi
done
