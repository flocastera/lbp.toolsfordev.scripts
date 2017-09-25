#!/bin/bash

path="$(pwd)"
echo
for D in `find . -maxdepth 1 -type d`
do
	test="$(echo $D | grep -E '(module|composants)\-applicatif' -c)"
	if [ $test -eq 1  ]; 
	then
		echo "Resetting (hard) for $(tput setaf 2)$(echo $D | grep -Eo "[a-zA-Z]*$")$(tput sgr 0)"
		dirPath="$path$(echo $D | sed 's/^.//')"
		cd $dirPath
		git reset --hard $1 $2 $3 $4
		cd ../
		echo 
	fi
done

