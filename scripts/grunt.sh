#!/bin/bash
################################B
# grunt.sh
# Appel : grunt/grt
# Description : Permet d'exécuter des tâches Grunt dans tous les projets (sauf watch)
# Args :
#   --all/-a    : Permet d'exécuter toutes les tâches communes (browserify et cssmin)
#   --detail/-d : Affiche la sortie de grunt dans la console
################################E

. $ROOT_PATH/functions.sh
args=`echo "$@" | grep -E -o "\-{1,2}[^($| )]+"`
tasks=`echo "$@" | grep -E -o "(^| )+[a-zA-Z]+"`

printHelp "$args" "grunt.sh" "Exécute les tâches Grunt passées en paramètres et présentes dans le Gruntfile.js" "grunt/grt" "--all/-a=Exécute browserify et cssmin;--detail/-d=Affiche la sortie console de Grunt" "lbp grunt -ad;lbp grt cssmin --detail"

hasArgument "$args" "all;a"
if [ $? -eq 1 ] ;
then
    tasks="browserify cssmin indexCompile"
fi

printTitle "Executing grunt tasks for all projects"
printInfo "Tasks : '$(tput setaf 2)$tasks$(tput sgr 0)'"
printInfo "Arguments : '$args'"

if [ `echo "$tasks" | grep "watch" -c` -gt 0 ] || [ -z "$tasks" ] ;
then
    printInfo "$(tput setaf 3)Attention!$(tput sgr 0) La tache 'watch' va bloquer l'exécution du script."
    printInfo "Sortie du programme..."
    printLine
    printEnd
    exit
fi
printLine

totalErrors=0
totalIgnored=0
totalSuccess=0

# Looping over directories in Workspace path
patterns=`cat $ROOT_PATH/.lbpexclude`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

for projectPath in $loops
do
    # Testing if directory pattern matches watched directories
    test=`find $projectPath -maxdepth 1 -name "Gruntfile.js" | sed '/^\s*$/d' | wc -l`
	projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

	if [ $test -ne 0 ] ;
	then
		cd $projectPath # Going into project folder to execute grunt commands

        resp=`grunt $tasks` # Executing grunt tasks

        if [ `echo "$resp" | grep "Done, without errors." -ci` != "0" ] ;
        then
		    let "totalSuccess = $totalSuccess + 1"

	        printProjectInfo "$projectName" "valid"
            printLine

            hasArgument "$args" "detail;d"
            if [ $? -eq 1 ] ;
            then
                echo "$resp" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
            else
	            printProjectLine "Tâches effectuées avec succès" "valid"
            fi
        elif [ `echo "$resp" | grep "Aborted" -ci` != "0" ] ;
        then
		    let "totalErrors = $totalErrors + 1"
	        printProjectInfo "$projectName" "error"
            printLine
            echo "$resp" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
        elif [ `echo "$resp" | grep "Fatal error" -ci` != "0" ] ;
        then
	        printProjectInfo "$projectName" "error"
	        printProjectLine "Pas de grunt ou pas de node_modules" "error"
        fi
	    printLine
    else
		let "totalIgnored = $totalIgnored + 1"
	    printProjectInfo "$projectName" "nc" "Pas de fichier Gruntfile.js"
	fi
done

printLine
printResumeStart
printResumeLine "Success" "$totalSuccess" "valid" 8
printResumeLine "Ignored" "$totalIgnored" "nc" 8
printResumeLine "Errors" "$totalErrors" "error" 8
printEnd
