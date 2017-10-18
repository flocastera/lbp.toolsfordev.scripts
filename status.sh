#!/bin/bash

path="$(pwd)"
modifiedFilesCount=0

for D in `find . -maxdepth 1 -type d`
do
	test="$(echo $D | grep -E '(module|composants)\-applicatif' -c)"
	if [ $test -eq 1  ]; 
	then
	    echo
		echo "Status for $(tput setaf 3)$(echo $D | grep -Eo "(H[0-9]{2}\-)?[a-zA-Z]*$")$(tput sgr 0)"
		dirPath="$path$(echo $D | sed 's/^.//')"
		cd $dirPath
		if [ "$1" == '-h' ] ;
		then
		    result="$(git status -s | grep -Ev 'AccreditationService|pom\.xml|\.properties|SecurityBouchonConfig|\.classpath|\.settings|\.gitignore')"
		    nb=$(echo "$result" | sed '/^\s*$/d' | wc -l)
		    let "modifiedFilesCount = $modifiedFilesCount + nb"
		    echo -n "$(tput setaf 2)"
		    echo "$result" | grep -E "^M.*"
		    echo -n "$(tput sgr 0)$(tput setaf 1)"
		    echo "$result" | grep -E "^\sM.*"
		    echo -n "$(tput sgr 0)"
		else
            git status -s
		    nb=$(git status -s | sed '/^\s*$/d' | wc -l)
		    let "modifiedFilesCount = $modifiedFilesCount + nb"
		fi
		cd ../
	fi
done

echo -e "──┬┬───────────────────────────────────────"
echo "  ||"
if [ "$modifiedFilesCount" == "0" ] ;
then
    echo "  ╘╧════> $(tput setaf 2)Workspace is clean !$(tput sgr 0)"
else
    echo "  ╘╧════> $(tput setaf 3)Modified/Added/Deleted/Merged files$(tput sgr 0)  : $modifiedFilesCount"
fi