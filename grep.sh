#!/bin/bash

path="$(pwd)"
echo
for D in `find . -maxdepth 1 -type d`
do
	test="$(echo $D | grep -E '(module\-applicatif|composants\-applicatif|lbp\.toolsfordev)' -c)"
	if [ $test -eq 1  ];
	then
	    defaultArgs="-nR --color --exclude-dir=\.(git|classpath|externalToolBuilders|project|settings) --exclude-dir=node_modules --exclude=npm-debug.log "
		echo "Grep results for $(tput setaf 2)$(echo $D | grep -Eo "(H[0-9]{2}\-)?[a-zA-Z]*$")$(tput sgr 0)"
		echo "  Default args : $(tput setaf 3)$defaultArgs$(tput sgr 0)"
		echo "  User args : $(tput setaf 3)$@$(tput sgr 0)"
		dirPath="$path$(echo $D | sed 's/^.//')"
		cd $dirPath
		grep $defaultArgs $1 $2 $3 $4
		cd ../
		echo
	fi
done