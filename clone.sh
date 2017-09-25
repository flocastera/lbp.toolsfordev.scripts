#!/bin/bash

path="$(pwd)"
server="https://git.sf.intra.laposte.fr/CC3_CAN/"
gitExt=".git"
echo
for repo in `cat repositories.txt`
do
	echo "Cloning repository $(tput setaf 2)$repo$(tput sgr 0)"
	if [ "$(echo $repo | grep -E '^https' -c)" == "0" ] ;
	then
	    repo="$server$repo"
	fi
	if [ "$(echo $repo | grep -E 'git$' -c)" == "0" ] ;
	then
	    repo="$repo$gitExt"
	fi
	echo $repo
	git clone $repo
	echo
done
