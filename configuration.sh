#!/bin/bash

# Pour cette variable :
#   soit la renseigner directement ici sous la forme de chemin absolu
#   soit la renseigner dans les variables d'environnement
# Cette variable doit obligatoirement être valorisé car tous les scripts l'utilisent pour
# lister les différents projets
# Exemple de valorisation dans ce fichier :
#   export WSP_PATH="D:/ATAD/VEDPSE/vne3cc/nomDuWorkspace8/"
export WSP_PATH=$WSP_PATH

export SCRIPTS_PATH=$WSP_PATH/lbp.toolsfordev.scripts/scripts
export repositoriesList="$WSP_PATH/repositories.txt"

# Sert à l'affichage des noms de projets, modifier la regexp si vous renommez vos projets
export projectNamePatterns="(module\-applicatif|composants\-applicatifs)\-(H[0-9]{2}\-)?[a-zA-Z]+"

# Variable qui permet d'isoler les projets (modules/composants) en excluant les dossiers non voulus (.metadata, ...)
export watchPatterns="(module\-applicatif|composants\-applicatifs)"

# Variable qui permet d'exclure certains dossiers volumineux/denses ou fichiers lors de l'affichage du status Git du projet
export excludedProjectPathsPatterns="AccreditationService|pom\.xml|\.properties|SecurityBouchonConfig|\.classpath|\.settings|\.gitignore"