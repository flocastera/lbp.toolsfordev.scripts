#!/bin/bash

path="$(pwd)"
echo
for D in `cat repositories.txt`
do
	echo "Cloning repository $(tput setaf 2)$D$(tput sgr 0)"
	git clone $D
	echo
done
