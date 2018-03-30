#!/bin/bash


################################B
# workspace.sh
# Appel : workspace/wsp
# Description : Permet d'ajouter un workpace, switcher de workspace et switcher de groupe d'exclusion
# Args :
#   --add/-a    : Ajouter un workspace ex => lbp wsp --add jdk8 /d/data/espdev/cc3env/workspaceJDK8
#   --switch/-s : Changer de workspace par défaut ex => lbp wsp -s jdk8
#   --group/-g  : Changer de groupe d'exclusions par défaut ex => lbp wsp --group h55
################################E


. $ROOT_PATH/functions.sh
args=$@


printHelp "$args" "workspace.sh" "Permet d'ajouter un workpace, switcher de workspace et switcher de groupe d'exclusion" "workspace/wsp" "--add/-a=Ajouter un workspace;--switch/-s=Changer le workspace par défaut;--group/-g=Permet de changer le groupe d'exclusion" "lbp wsp -a jdk8 /chemin/du/workspace;lbp wsp -s;lbp wsp -s jdk8;lbp wsp -g;lbp wsp -g h55"


path="$(pwd)"

#Pour ajouter un workspace
hasArgument "$args" "add;a"
if [ $? -eq 1 ] ;
then
    if [ -n "$2" ] && [ -n "$3" ] ;
    then
        wspName="$2"
        wspPath="$3"
        echo
        if [ -d "$wspPath" ] ;
        then
            # TODO : remplacement
            strToAdd="$WORKSPACES;$wspName==$wspPath"
            sed -i -e "s@export WORKSPACES=.*@export WORKSPACES=\"${strToAdd}\"@g" $ROOT_PATH/configuration.sh
            echo "Workspace ajouté, nom : '$wspName', chemin : '$wspPath'"
        else
            echo "Le chemin spécifié n'existe pas ou n'est pas un dossier..."
        fi
        echo
    fi
fi

# Pour switcher entre les workspace
hasArgument "$args" "switch;s"
if [ $? -eq 1 ] ;
then
    if [ -n "$2" ] ;
    then
        wspsEach=`echo "$WORKSPACES" | tr ';' '\n' | sed '/^\s*$/d'`
        found=`echo "$wspsEach" | grep -E "^${2}.*" | tail -n 1 | sed -r 's@^[^=]+==@@g'`
        if [ -n "$found" ];
        then
            setx WSP_PATH "$found" 2>&1
            sed -i -e "s@export WSP_PATH=.*@export WSP_PATH=\"${found}\"@g" $ROOT_PATH/configuration.sh
            echo "Le workspace $2 a été enregistré comme workspace par défaut. Chemin : '$found'"
        else
            echo "Aucun workspace correspondant !"
        fi
    else
        echo "Pas de paramètres !"
    fi
fi

# Pour switcher entre les projets exclus
hasArgument "$args" "group;g"
if [ $? -eq 1 ] ;
then
    if [ -f "$ROOT_PATH/$2.lbpexclude" ] ;
    then
        sed -i -e "s@export EXCLUDE_GROUP_FILE=.*@export EXCLUDE_GROUP_FILE=\"${ROOT_PATH}/${2}.lbpexclude\"@g" $ROOT_PATH/configuration.sh
        setx EXCLUDE_GROUP_FILE "$ROOT_PATH/$2.lbpexclude" 2>&1
        echo
    else
        echo "Le fichier spécifié n'existe pas !"
    fi
fi