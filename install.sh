#!/bin/bash

echo
echo "$(tput setaf 2)Lancement de l'installation...$(tput sgr 0)"
echo "Certaines actions nécessitent l'intervention de l'utilisateur."

scriptsPath=`pwd`

echo
echo "[$(tput setaf 3)!$(tput sgr 0)] Le répertoire racine des scripts est '$(tput setaf 2)$scriptsPath$(tput sgr 0)'"
echo

# Paramètrage du fichier configuration.sh
sed -i -e "s@ROOT_PATH=.*@ROOT_PATH=${scriptsPath}@g" $scriptsPath/scripts.sh
sed -i -e "s@SCRIPTS_PATH=.*@SCRIPTS_PATH=${scriptsPath}/scripts@g" $scriptsPath/configuration.sh
sed -i -e "s@repositoriesList=.*@repositoriesList=${scriptsPath}/repositories.txt@g" $scriptsPath/configuration.sh

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
