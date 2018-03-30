#!/bin/bash

scriptsPath=`pwd`
sourcePath="//ecp.sf.local/_commun-vlp/_COMMUN/_Projet/Cap Client 3.0/R4-Release 4/VTE-EER et Multivente_/OUTILS/lbp.toolsfordev.scripts"

if [ "$#" -gt 0 ] && [ "$1" == "-u" ];
then
    ####################
    ### MISE A JOUR
    ####################
    echo
    echo "[$(tput setaf 3)O$(tput sgr 0)] Mise à jour du lanceur..."
    echo " │"
    cp -v "$sourcePath/functions.sh" "$ROOT_PATH/functions.sh" | cut -d/ -f11- | sed "s/^/ ╞──'/g"
    cp -v "$sourcePath/scripts.sh" "$ROOT_PATH/scripts.sh" | cut -d/ -f11- | sed "s/^/ ╞──'/g"
    echo " │"
    echo "[$(tput setaf 2)V$(tput sgr 0)] Mise à jour du lanceur terminée !"

    echo
    echo "[$(tput setaf 3)O$(tput sgr 0)] Mise à jour des scripts..."
    echo " │"
    cp -v -r "$sourcePath/scripts/" "$ROOT_PATH/" | cut -d/ -f11- | sed "s/^/ ╞──'/g"
    echo " │"
    echo "[$(tput setaf 2)V$(tput sgr 0)] Mise à jour des scripts terminée !"

    echo
    echo "=== Notes de version ==="
    echo
    relversion=`cat "$sourcePath/RELEASE_NOTES" | head -n 1`
    reldate=`cat "$sourcePath/RELEASE_NOTES" | head -n 2 | tail -n 1`
    relnotes=`cat "$sourcePath/RELEASE_NOTES" | tail -n+3`
    echo "Version : $(tput setaf 2)$relversion$(tput sgr 0)"
    echo "Date : $(tput setaf 2)$reldate$(tput sgr 0)"
    echo
    echo "$relnotes"
    echo
else
    ####################
    ### INSTALLATION
    ####################

    echo
    echo "$(tput setaf 2)Lancement de l'installation...$(tput sgr 0)"
    echo "Certaines actions nécessitent l'intervention de l'utilisateur."

    echo
    echo "[$(tput setaf 3)!$(tput sgr 0)] Le répertoire racine des scripts est '$(tput setaf 2)$scriptsPath$(tput sgr 0)'"
    echo

    # Paramètrage du fichier configuration.sh
    setx ROOT_PATH "$scriptsPath"
    setx EXCLUDE_GROUP_FILE "$ROOT_PATH/.lbpexclude"
    sed -i -e "s@SCRIPTS_PATH=.*@SCRIPTS_PATH=${scriptsPath}/scripts@g" $scriptsPath/configuration.sh
    sed -i -e "s@repositoriesList=.*@repositoriesList=${scriptsPath}/repositories.txt@g" $scriptsPath/configuration.sh
    sed -i -e "s@EXCLUDE_GROUP_FILE=.*@EXCLUDE_GROUP_FILE=${scriptsPath}/.lbpexclude@g" $scriptsPath/configuration.sh

    if [ ! -f $scriptsPath/.lbpexclude ]; then
        touch $scriptsPath/.lbpexclude
        echo "# Entrer ici le nom d'un projet à exclure (Exemple: FinalisationEntretien ou composants-applicatifs-VentePanier)" > .lbpexclude
    fi

    # Création du .bashrc
    if [ ! -f ~/.bashrc ]; then
        echo "[$(tput setaf 3)!$(tput sgr 0)] Création d'un fichier .bashrc dans le répertoire personnel..."
        echo
        touch ~/.bashrc
        echo "#!/bin/bash" > ~/.bashrc
    fi

    # Ajout d'un alias
    if [ `grep -c -E "alias lbp=" ~/.bashrc` -eq 0 ] ;
    then
        echo "[$(tput setaf 3)!$(tput sgr 0)] Ajout d'un alias pour lancer les scripts : '$(tput setaf 2)lbp$(tput sgr 0)'"
        echo "" >> ~/.bashrc
        echo "# Alias permettant de lancer les scripts" >> ~/.bashrc
        echo "alias lbp='${scriptsPath}/scripts.sh'" >> ~/.bashrc
    fi

    echo
    read -p "Configurer un workspace maintenant ? (y/n) : " valid
    echo
    if [ "$valid" == "y" ] || [ "$valid" == "Y" ] ;
    then
        read -p "Nom du workspace : " wspName
        read -p "Chemin du workspace : " wspPath
    else
        echo "$(tput setaf 1)Ne pas oublier de configurer un workspace => lbp wsp -a <nom> <chemin>$(tput sgr 0)"
        echo "$(tput setaf 1)Et surtout de le mettre par défaut => lbp wsp -s <nom> !$(tput sgr 0)"
    fi

    echo
    echo "$(tput setaf 2)Installation terminée$(tput sgr 0)"
    echo
    echo "[$(tput setaf 3)!$(tput sgr 0)] Pour prendre en compte les modifications, redémarrer la CLI."
    echo "[$(tput setaf 3)!$(tput sgr 0)] Une fois la CLI relancée, tapez lbp --help pour vérifier que tout a bien fonctionné."
    echo
fi