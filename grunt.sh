#!/bin/bash

tasks=$@

echo
echo "$(tput setaf 2)Executing grunt tasks for all projects...$(tput sgr 0)"
echo "─┬────────────────────────────"
echo " │"
echo " ╞──Tasks : '$(tput setaf 2)$tasks$(tput sgr 0)'"
echo " │"

totalErrors=0
totalIgnored=0
totalSuccess=0

# Looping over directories in Workspace path
for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
    # Testing if directory pattern matches watched directories
    test=`find $projectPath -maxdepth 1 -name "Gruntfile.js" | sed '/^\s*$/d' | wc -l`
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
	if [ "$test" != "0" ] ;
	then
		cd $projectPath # Going into project folder to execute grunt commands

        resp=`grunt $tasks` # Executing grunt tasks

        if [ `echo "$resp" | grep "Done, without errors." -ci` != "0" ] ;
        then
		    let "totalSuccess = $totalSuccess + 1"

	        echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
            echo " │"
            if [ `echo "$@" | grep "(--detail)+" -ciE` != "0" ] ;
            then
                echo "$resp" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
            else
	            echo " ╞───Tâches effectuées avec succès"
            fi
            echo " │"
        elif [ `echo "$resp" | grep "Aborted" -ci` != "0" ] ;
        then
		    let "totalErrors = $totalErrors + 1"

	        echo "[$(tput setaf 1)x$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0)"
            echo " │"
            echo "$resp" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
            echo " │"
        fi
    else
		let "totalIgnored = $totalIgnored + 1"

	    echo "[$(tput setaf 3)o$(tput sgr 0)]──$(tput setaf 2)$projectName$(tput sgr 0) ne contient pas de Gruntfile.js"
	fi
done

echo " │"
echo "─╪────────────────────────────"
echo " ╞─ $(tput setaf 2)Success$(tput sgr 0)  : $totalSuccess"
echo " ╞─ $(tput setaf 3)Ignored$(tput sgr 0)  : $totalIgnored"
echo " ╞─ $(tput setaf 1)Errors $(tput sgr 0)  : $totalErrors"
echo " ╘────────────────────────────"
