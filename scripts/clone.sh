#!/bin/bash

repositoriesListFile="$repositoriesList"

localProjects=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
localProjectsName=`echo "$localProjects" | sed -e "s@$WSP_PATH/@@g"`

totalReplaced=0
totalAdded=0
totalErrors=0
totalIgnored=0

echo
echo "$(tput setaf 2)Cloning projects in $(tput sgr 0)$repositoriesListFile$(tput setaf 2) from depositories...$(tput sgr 0)"
echo "─┬────────────────────────────"
echo " │"

for repo in `cat $repositoriesListFile`
do
    repoName=`echo "$repo" | sed -e "s@^.*/@@g" | sed -e "s@\\.git\\$@@g"`
    exists=`echo "$localProjectsName" | grep "$repoName" -c`
    resp=""
    forced="0"
    if [ "$exists" == "1" ] && [ "$1" != "-f" ] ;
    then
        echo "[$(tput setaf 3)o$(tput sgr 0)]──$(tput setaf 2)$repoName$(tput sgr 0) existe déjà dans le workspace ! Passage au suivant..."
		let "totalIgnored = $totalIgnored + 1"
    elif [ "$exists" == "1" ] ;
    then
        rm -rf $WSP_PATH/$repoName
        resp=`git clone $repo $repoName 2>&1 >/dev/null`
        forced="1"
    else
        resp=`git clone $repo $repoName 2>&1 >/dev/null`
    fi

    if [ `echo "$resp" | grep -ci "fatal"` -gt 0 ] ;
    then
        echo "[$(tput setaf 1)X$(tput sgr 0)]──$(tput setaf 2)$repoName$(tput sgr 0)"
		let "totalErrors = $totalErrors + 1"
        if [ `echo "$resp" | grep -ci "remote: not found"` -gt 0 ] ;
        then
            echo " ╞───Dépôt distant non trouvé !"
            echo " ╞───URL : $(tput setaf 3)$repo$(tput sgr 0)"
        fi
        if [ `echo "$resp" | grep -ci "fatal: unable to access"` -gt 0 ] ;
        then
            echo " ╞───Accès au dépôt distant refusé !"
            echo " ╞───URL : $(tput setaf 3)$repo$(tput sgr 0)"
        fi
    elif [ "$resp" != "" ] ;
    then
        if [ "$forced" == "1" ] ;
        then
		    let "totalReplaced = $totalReplaced + 1"
		else
		    let "totalAdded = $totalAdded + 1"
        fi
        echo "[$(tput setaf 2)V$(tput sgr 0)]──$(tput setaf 2)$repoName$(tput sgr 0) créé avec succès !"
    fi
done

echo " │"
echo "─╪────────────────────────────"
echo " ╞─ $(tput setaf 3)Ignored$(tput sgr 0)  : $totalIgnored"
echo " ╞─ $(tput setaf 2)Added$(tput sgr 0)    : $totalAdded"
echo " ╞─ $(tput setaf 2)Replaced$(tput sgr 0) : $totalReplaced"
echo " ╞─ $(tput setaf 1)Errors $(tput sgr 0)  : $totalErrors"
echo " ╘────────────────────────────"
