#!/bin/bash

path="$(pwd)"
echo
for D in `find . -maxdepth 1 -type d`
do
	test="$(echo $D | grep -E '(module|composants)\-applicatif' -c)"
	if [ $test -eq 1  ]; 
	then
		echo "Switching to branch $(tput setaf 3)$1$(tput sgr 0) for $(tput setaf 2)$(echo $D | grep -Eo "(H[0-9]{2}\-)?[a-zA-Z]*$")$(tput sgr 0)"
		dirPath="$path$(echo $D | sed 's/^.//')"
		cd $dirPath
		git checkout $1 $2 $3 $4
		cd ../
		echo 
	fi
done

