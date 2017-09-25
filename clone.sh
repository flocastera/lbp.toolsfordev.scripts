#!/bin/bash

path="$(pwd)"
echo
for D in `cat repositories.txt`
do
	echo "Cloning repository $(tput setaf 2)$D$(tput sgr 0)"
	if [ "$(grep -E '^https' -c)" == "0" ]
	then
	    D="https://git.sf.intra.laposte.fr/CC3_CAN/$D"
	fi
	if [ "$(grep -E '\.git$' -c)" == "0" ]
	then
	    D="$D.git"
	fi
	echo $D
	git clone $D
	echo
done
