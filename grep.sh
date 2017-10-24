#!/bin/bash

defaultArgs="-nR --color=always $3 $4 $5"
exludesPaths="--exclude-dir=\.(git|classpath|externalToolBuilders|project|settings) --exclude-dir=node_modules --exclude-dir=target --exclude=npm-debug.log"
search=$2
totalMatchCount=0
totalMatchProject=0
dumpfile="$WSP_PATH/grep_results.txt"

echo
echo "$(tput setaf 2)Executing 'grep' command in all projects...$(tput sgr 0)"
echo "─┬─────────────────────────────────────────"
echo " ╞──Search : '$(tput setaf 2)$search$(tput sgr 0)'"
echo " ╞──Args : $defaultArgs"
echo " ╞──Excluded : $(tput setaf 3)$exludesPaths$(tput sgr 0)"
echo " │"

for projectPath in `find $WSP_PATH -maxdepth 1 -type d`
do
	test="$(echo $projectPath | grep -E "$watchPatterns" -c)"
	if [ $test -eq 1  ];
	then
		cd $projectPath
		result=`grep $defaultArgs $exludesPaths $search`
		let "count=`echo "$result" | wc -l` - 1"
		projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

        if [ $count -gt 0 ] ;
        then
	        echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
		    let "totalMatchCount = $totalMatchCount + $count"
		    let "totalMatchProject = $totalMatchProject + 1"

		    if [ "$1" == "--count-only" ] ;
		    then
                echo " ╞───Matches : $count"
            elif [ "$1" == "--count" ] ;
            then
                echo " ╞───Matches : $count"
                echo "" >> $dumpfile
                echo "===================[ $projectName ]===================" >> $dumpfile
                echo "" >> $dumpfile
                grep $defaultArgs $exludesPaths $search >> $dumpfile
                echo "" >> $dumpfile
            elif [ "$1" == "--matches" ] ;
            then
                grep $defaultArgs $exludesPaths $search | sed 's/^/ ╞───/g'
                echo " ╞───Matches : $count"
		    fi
		else
	        echo "[$(tput setaf 1)X$(tput sgr 0)] No results in $(tput setaf 2)$(echo $projectPath | grep -Eo "$projectNamePatterns")$(tput sgr 0)"
        fi
	fi
done
echo " │"
echo "─╪───────────────────────────────"
echo " ╞─ Total match count      : $(tput setaf 2)$totalMatchCount$(tput sgr 0)"
echo " ╞─ Total match project    : $(tput setaf 2)$totalMatchProject$(tput sgr 0)"
echo " ╘───────────────────────────────"

if [ "$1" == "--count" ] ;
then
    echo
    read -p "Voir les résultats ? (y/n) " resp
    if [ "$resp" == "y" ] ;
    then
        echo
        cat $dumpfile
    fi
fi
rm -f $dumpfile &> /tmp/tmp