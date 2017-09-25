#! /bin/bash

if [ $# -ne 0 ]
then
	if [ $1 == 'couchbase' ]
	then 
		ping 220.4.101.161 -n 1
	elif [ -z $1 ]
	then
		ping $1
	fi
else
    echo
    echo "$(tput setaf 1)No arguments sent.$(tput sgr 0)"
    echo "You need to specify at least an IP address or a service name"
    echo "ex: couchbase or 192.168.0.1"
fi