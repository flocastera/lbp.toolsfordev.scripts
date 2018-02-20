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
    sed -i -e "s@SCRIPTS_PATH=.*@SCRIPTS_PATH=${scriptsPath}/scripts@g" $scriptsPath/configuration.sh
    sed -i -e "s@repositoriesList=.*@repositoriesList=${scriptsPath}/repositories.txt@g" $scriptsPath/configuration.sh

    if [ ! -f /tmp/foo.txt ]; then
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
    echo "[$(tput setaf 3)!$(tput sgr 0)] Merci de créer une variable d'environnement de compte nommé 'WSP_PATH'"
    echo "[$(tput setaf 3)!$(tput sgr 0)] Procédure : "
    echo "      1. Ouvrir le menu démarrer"
    echo "      2. Taper 'variable' et sélectionner 'Modifier les variables d'environnements pour votre compte'"
    echo "      3. Cliquer sur 'Nouvelle', renseigner 'WSP_PATH' dans le premier champ"
    echo "      4. Pour connaître l'emplacement du workspace, aller dedans avec git bash et taper 'pwd'"
    echo "      5. Coller dans le second champ ce qui a été produit par la commande précédente"

    echo
    read -p "Valider l'action précédente (y/n) : " valid
    echo
    if [ "$valid" == "y" ] || [ "$valid" == "Y" ] ;
    then
        echo "$(tput setaf 2)Installation terminée$(tput sgr 0)"
    else
        echo "$(tput setaf 1)Les scripts ont besoin de la variable d'environnement !$(tput sgr 0)"
    fi

    echo
    echo "[$(tput setaf 3)!$(tput sgr 0)] Pour prendre en compte les modifications, redémarrer la CLI."
    echo "[$(tput setaf 3)!$(tput sgr 0)] Une fois la CLI relancée, tapez lbp --help pour vérifier que tout a bien fonctionné."
    echo
fi