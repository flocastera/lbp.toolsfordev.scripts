#!/bin/bash

################################B
# uid.sh
# Appel : userId/uid
# Description : Permet de modifier le code conseiller dans les fichiers SecurityBouchonConfig.xml
# Args :
#   --list/-l   : Permet d'afficher tous les codes conseillers sans les modifier
################################E

. $ROOT_PATH/functions.sh

args=`echo "$@" | grep -E -o "\-{1,2}[^($| )]+"`
userId=`echo "$@" | grep -E -o "(^| )+[a-zA-Z0-9]+"`

printHelp "$args" "uid.sh" "Modifie l'userId dans les SecurityBouchonConfig.xml" "userId/uid" "--list/-l=Permet d'afficher les valeurs plutôt que les modifier" "lbp uid 'TCCA001';lbp uid --list"

path="$(pwd)"
modifiedFilesCount=0
ignoredFilesCount=0
errorsFilesCount=0
file=""

printTitle "Setting UserId for projects"
printInfo "Arguments : '$args'"
printInfo "New userId : '$(tput setaf 2)$userId$(tput sgr 0)'"
printLine

for projectPath in `find $WSP_PATH -maxdepth 1 -type d | grep -E "$watchPatterns"`
do
    cd $projectPath
    projectName=$(echo $projectPath | grep -Eo "$projectNamePatterns")

    files=`find $projectPath/src/ -name "SecurityBouchonConfig.xml"`

    if [ "$files" != "" ] ;
    then
        printProjectInfo "$projectName" "valid"

        for file in $files
        do
            minFile=`echo "$file" | sed -e "s@$projectPath@@g"`
            hasArgument "$args" "list;l"
            if [ $? -eq 1 ] || [ -z "$userId" ] ;
            then
                resultSearch=`grep -E "<property name=\"userId\" value=\".*\"[ ]*\\/>" $file | grep -Eo "value=\".*\"" | grep -Eo "\".*\""`
                printProjectLine "$minFile => $(tput setaf 2)$resultSearch$(tput sgr 0)"
            else
                sed -i -e "s@<property name=\"userId\" value=\".*\"[ ]*\\/>@<property name=\"userId\" value=\"$userId\" \\/>@g" $file
                result=`grep -Ec "<property name=\"userId\" value=\"$userId\"(\s)*/>" $file`

                if [ $result -gt 0 ] ;
                then
                    printProjectLine "UserId successfully changed in $minFile"
                    let "modifiedFilesCount = $modifiedFilesCount + 1"
                else
                    printProjectLine "Unable to change userId in $minFile !$(tput sgr 0)"
                    let "ignoredFilesCount = $ignoredFilesCount + 1"
                fi
            fi
        done
        printLine
    else
        let "errorsFilesCount = $errorsFilesCount + 1"
        printProjectInfo "$projectName" "nc"
        printProjectLine "Pas de fichier 'SecurityBouchonConfig.xml' !"
        printLine
    fi
done

printResumeStart
printResumeLine "Modified" "$modifiedFilesCount" "valid"
printResumeLine "Errors" "$errorsFilesCount" "error"
printResumeLine "Ignored" "$ignoredFilesCount" "nc"
printEnd