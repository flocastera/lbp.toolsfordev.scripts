#!/bin/bash

path="$(pwd)"
echo
for D in `find . -maxdepth 1 -type d`
do
	test="$(echo $D | grep -E '(module|composants)\-applicatif' -c)"
	if [ $test -eq 1  ]; 
	then
		echo "Pulling $(tput setaf 2)$(echo $D | grep -Eo "(H[0-9]{2}\-)?[a-zA-Z]*$")$(tput sgr 0) with args : $(tput setaf 3)$1 $2 $3 $4$(tput sgr 0)"
		dirPath="$path$(echo $D | sed 's/^.//')"
		cd $dirPath
		git pull $1 $2 $3 $4
		git checkout integration_0_4 2>> /tmp/.tmp 1>> /tmp/.tmp 0>> /tmp/.tmp
		cd ../
		echo 
	fi
done
