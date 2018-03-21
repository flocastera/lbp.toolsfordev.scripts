#!/bin/bash
################################B
# stats.sh
# Appel : stats/sta
# Description : Permet de faire des stats sur l'optimisation de code
# Args :
#   --all/-a            : Permet d'exécuter toutes les stats (Grunt, TODO, TU)
#   --gruntWarnings/-g  : Permet d'exécuter les stats Grunt
#   --javaTests/-j      : Permet d'exécuter les stats sur les TU java
#   --todo/-t           : Permet de lister tous les TODO
#   --print/-p          : Affiche la sortie dans la console
################################E

. $ROOT_PATH/functions.sh
args=`echo "$@"`

printHelp "$args" "grunt.sh" "Exécute les tâches Grunt passées en paramètres et présentes dans le Gruntfile.js" "grunt/grt" "--all/-a=Exécute browserify et cssmin;--detail/-d=Affiche la sortie console de Grunt" "lbp grunt -ad;lbp grt cssmin --detail"


printTitle "Executing grunt tasks for all projects"
printInfo "Arguments : '$args'"
printLine

totalRun=0
totalFail=0
totalErr=0
totalSkip=0

totalTODO=0

fileToExport="$WSP_PATH/statsDump.html"
rm -f $fileToExport

# Searching projects to look for
patterns=`cat $EXCLUDE_GROUP_FILE`
loops=`find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns" | grep -F -v "${patterns}"`

##################################
# DEBUT WARNINGS GRUNT
##################################
hasArgument "$args" "gruntWarnings;all;g;a"
if [ $? -eq 1 ] ;
then

    hasArgument "$args" "print;p"
    if [ $? -eq 0 ] ;
    then
        echo "<h1>Grunt</h1>" >> $fileToExport
    fi


    printProjectInfo "STARTING GRUNT WARNINGS SEARCH" "nc"
    printLine

    for projectPath in $loops
    do

        testGrunt=`find $projectPath -maxdepth 1 -name "Gruntfile.js" | sed '/^\s*$/d' | wc -l`
        respGrunt=""
        if [ $testGrunt -ne 0 ] ;
        then
            projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
            printProjectInfoTemp $projectName "nc"

            cd $projectPath

            respGrunt=`grunt eslint:src eslint:test`

            if [ `echo "$respGrunt" | grep "Done, without errors." -ci` != "0" ] ;
            then
                let "totalSuccess = $totalSuccess + 1"


                if [ `echo "$respGrunt" | grep -E "[0-9]+ problem" -ci` != "0" ] ;
                then
                    printProjectInfo "$projectName" "nc"
                else
                    printProjectInfo "$projectName" "valid"
                fi


                hasArgument "$args" "print;p"
                if [ $? -eq 1 ] ;
                then
                    echo "$respGrunt" | sed "s/^/ ╞───/g" | sed "/^ ╞───$/d"
                else
                    #TODO export to file
                    echo "  <h2>$projectName<h2>" >> $fileToExport
                    echo "$respGrunt" | sed "/^\s*$/d" | sed -e "s@^@<p>@g" | sed -e "s@\$@</p>@g" >> $fileToExport
                    printProjectLine "Tâches effectuées avec succès" "valid"
                fi
            else
                printProjectInfo "$projectName" "error"
                printProjectLine "Erreurs à l'éxécution de la tâche Grunt" "error"
            fi
            printLine

        else
            printProjectInfo $projectName "error" "Pas de Gruntfile.js"
        fi
    done

    printLine
    printProjectInfo "ENDING GRUNT WARNINGS SEARCH" "valid"
    printLine
    printResumeStart
fi
##################################
# FIN WARNINGS GRUNT
##################################




##################################
# DEBUT TODO/FIXME SEARCH
##################################

hasArgument "$args" "todo;all;t;a"
if [ $? -eq 1 ] ;
then

    printProjectInfo "STARTING 'TODO' AND 'FIXME' SEARCH" "nc"
    printLine

    for projectPath in $loops
    do
        projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
        printProjectInfoTemp $projectName "nc"

        cd $projectPath

        defaultArgs="-nRE --color=always"
        exludesPaths="--exclude-dir=\.(git|classpath|externalToolBuilders|project|settings) --exclude-dir=node_modules --exclude-dir=target --exclude=npm-debug.log --exclude=*.log --exclude=*bundle.js --exclude=*bundle-test.js --exclude=*bundle-test-integration.js --exclude=*bundle.min.js"

        resp=`grep $defaultArgs $exludesPaths "(TODO|FIXME)"`
        nbTODOs=`echo "$resp" | sed "/^(\s)*$/d" | wc -l`

        if [ $nbTODOs -eq 0 ] ;
        then
            printProjectInfo $projectName "valid"
        else
            printProjectInfo $projectName "error"
        fi
        echo "$resp" | sed "/^\.git.*/d"
        let "totalTODO = $totalTODO + $nbTODOs"
        echo

    done

    printLine
    printProjectInfo "ENDING 'TODO' AND 'FIXME' SEARCH" "valid"
    printLine
    printResumeStart
fi
##################################
# FIN TODO/FIXME SEARCH
##################################





##################################
# DEBUT TESTS UNITAIRES JAVA
##################################
hasArgument "$args" "javaTests;all;j;a"
if [ $? -eq 1 ] ;
then

    printProjectInfo "STARTING JAVA UNIT TESTS" "nc"
    printLine

    for projectPath in $loops
    do
        projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")
        printProjectInfoTemp $projectName "nc"

        cd $projectPath
        respJava=`/d/DATA/ESPDEV/apache-maven-3.3.9/bin/mvn.cmd clean install 2>&1`

        if [ -n "$respJava" ] && [ `echo "$respJava" | grep -c " T E S T S"` -gt 0 ] ; # TODO delete hasArguments
        then

            printProjectInfo $projectName "valid"

            testCount=`echo "$respJava" | grep -a -E "Tests run: [0-9]+(,[a-zA-Z ]+: [0-9]+){4,}"`

            totalProjectRun=0
            totalProjectFail=0
            totalProjectErr=0
            totalProjectSkip=0

            while read -r testEntry; do

                whichFile=`echo "$testEntry" | grep -o -E "\- in .*" | sed 's/- in //g' | grep -E "[a-zA-Z0-9_]+$" --color=always | sed "s/fr.laposte.disf.canal.//g"`
                testsRun=`echo "$testEntry" | grep -o -E "run: [0-9]+" | sed 's/run: //g'`
                testsFail=`echo "$testEntry" | grep -o -E "Failures: [0-9]+" | sed 's/Failures: //g'`
                testsErr=`echo "$testEntry" | grep -o -E "Errors: [0-9]+" | sed 's/Errors: //g'`
                testsSkip=`echo "$testEntry" | grep -o -E "Skipped: [0-9]+" | sed 's/Skipped: //g'`
                testsTime=`echo "$testEntry" | grep -o -E "Time elapsed: [0-9\.]+" | sed 's/Time elapsed: //g'`

                let "totalProjectRun = $totalProjectRun + $testsRun"
                let "totalProjectFail = $totalProjectFail + $testsFail"
                let "totalProjectErr = $totalProjectErr + $testsErr"
                let "totalProjectSkip = $totalProjectSkip + $testsSkip"

                if [ "$testsErr" != "0" ] || [ "$testsFail" != "0" ] ;
                then
                    printProjectLine "$whichFile => Run: $testsRun / Skipped: $testsSkip / $(tput setaf 1)Fail: $testsFail$(tput sgr 0) / $(tput setaf 1)Err: $testsErr$(tput sgr 0) / Time: $testsTime seconds" "error"
                else
                    printProjectLine "$whichFile => $(tput setaf 2)OK$(tput sgr 0) ($testsRun tests run, $testsSkip skipped in $testsTime seconds)" "valid"
                fi
            done <<< "$testCount"

            printLine

            if [ "$testsErr" != "0" ] || [ "$testsFail" != "0" ] ;
            then
                printProjectLine "Run : $totalProjectRun, skipped : $totalProjectSkip, failed : $totalProjectFail, errors : $totalProjectErr" "error"
            else
                printProjectLine "Run : $totalProjectRun, skipped : $totalProjectSkip, failed : $totalProjectFail, errors : $totalProjectErr"
            fi


            let "totalRun = $totalProjectRun + $totalRun"
            let "totalFail = $totalProjectFail + $totalFail"
            let "totalErr = $totalProjectErr + $totalErr"
            let "totalSkip = $totalProjectSkip + $totalSkip"

        elif [ -n "$respJava" ] && [ `echo "$respJava" | grep -c " T E S T S"` -eq 0 ] ;
        then
            printProjectInfo $projectName "valid" "Pas de tests..."
        elif [ -z "$respJava" ] ;
        then
            printProjectInfo $projectName "nc" "Command not executed !"
        else
            printProjectInfo $projectName "error" "Build failure !"
        fi
        printLine

    done

    printLine
    printProjectInfo "ENDING JAVA UNIT TESTS" "nc"

fi

##################################
# FIN TESTS UNITAIRES JAVA
##################################

printLine
printResumeStart
printResumeLine
printResumeLine "Java tests"
printResumeLine "──Run" "$totalRun" "valid" 10
printResumeLine "──Skipped" "$totalFail" "nc" 10
printResumeLine "──Errors" "$totalErr" "error" 10
printResumeLine "──Failed" "$totalFail" "error" 10
printResumeLine
printResumeLine "TODO/FIXME search"
printResumeLine "──Total" "$totalTODO" "valid" 10
printResumeLine
printEnd
