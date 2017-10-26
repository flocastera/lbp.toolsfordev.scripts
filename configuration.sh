#!/bin/bash

# Pour cette variable :
#   soit la renseigner directement ici sous la forme de chemin absolu
#   soit la renseigner dans les variables d'environnement
# Cette variable doit obligatoirement être valorisé car tous les scripts l'utilisent pour
# lister les différents projets
# Exemple de valorisation dans ce fichier :
#   export WSP_PATH="D:/DATA/ESPDEV/cc3env/workspaceJDK8/"
export WSP_PATH=$WSP_PATH

export SCRIPTS_PATH=$WSP_PATH/lbp.toolsfordev.scripts/scripts

export repositoriesList="$WSP_PATH/repositories.txt"
export projectNamePatterns="(H[0-9]{2}\-)?[a-zA-Z]*$"
export watchPatterns="(module\-applicatif|composants\-applicatifs)"
export excludedProjectPathsPatterns="AccreditationService|pom\.xml|\.properties|SecurityBouchonConfig|\.classpath|\.settings|\.gitignore"