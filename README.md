# lbp.toolsfordev.scripts

Provides scripts to use with git or command line

## Usage :
Dans un invité de commande Bash (celui installé avec GIT par exemple), taper :
* Si emplacement du programme renseigné dans un alias :
```bash
nomAlias <nomScript> [parametres] 
```
* Sinon :
```bash
emplacementProjet/scripts.sh <nomScript> [parametres] 
```

## Scripts disponibles :
##### clone (gcl) 
Clone tous les répertoires présents dans le fichier repositories.txt, situé à la racine du workspace.
L'emplacement et le nom de ce fichier peuvent être modifiés dans le [fichier configuration.sh](configuration.sh),
variable 'repositoriesList'.
* --force : remplace les projets existants (effectue une suppression du dossier puis un clone)
##### grep (grp)
Exécute une commande grep dans tous les répertoires du workspace. Possibilité de juste compter les occurences, d'afficher les occurences, ou de compter les occurences puis de les afficher à la fin du traitement
* --count : permet de compter les occurences (uniquement)
* --count-only : permet de compter les occurences dans tous les projets puis de les afficher quand tous les projets sont analysés
##### grunt (grt)
Exécute des tâches Grunt (présentes dans le fichier Gruntfile.js) à la racine des projets (les projets n'en contenant pas seront ignorés)
* --detail : affiche la sortie standard et d'erreur de grunt (si pas renseigné, affiche un message annoncant si les tâches ont réussi ou non)
##### pom (po)
Affiche la version du pom de chaque projet (si un pom est présent). Peut également afficher la version des
dépendances, et ainsi les synchroniser si elles sont tirées en local.
* -f/--full : affiche la version des dépendances
* -s/--sync : permets de synchroniser les versions des dépendances
##### pull (gpl)
Permet d'effectuer un pull sur tous les projets. Un stash peut être appliqué avant de manière automatique en utilisant 
l'option correspondante. La statégie de merge peut être définie également depuis une option
* --stash : éxécute 'git stash' avant de faire le 'git pull', puis éxécute un 'git stash pop' si tout s'est bien passé
* --force : permet de spécifier une stratégie de merge, cett option est équivalente à faire un 'git pull -X theirs'
##### status (gst)
Affiche le statut de tous les projets contenant un .git. Ce statut peut être détaillée ou non, et certains fichiers 
peuvent être exclus dans le [fichier configuration.sh](configuration.sh), variable 'excludedProjectPathsPatterns'
* -h : masque les fichiers exlus de l'affichage du statut
##### userId (uid)
Permet de modifier la valeur de l'userId dans les fichiers '*/SecurityBouchonConfig.xml' des tous les projets

__Attention :__ les fichiers 'target/*/SecurityBouchonConfig.xml' ne sont pas modifiés

__Exemple :__ lbpscripts uid TCCA001

## Configuration optimale :
1. Déposer/cloner ce projet à la racine de votre workspace (à coté des composants/modules)
2. Créer une variable d'environnement $WSP_PATH ciblant la racine de votre workspace
3. Créer un alias permettant d'accéder au script de lancement '[scripts.sh](script.sh)'
* Exemple : alias lbpscripts="D:/workspaceJDK8/lbp.toolsfordev.scripts/scripts.sh"
4. Vérifier la validité des variables dans le fichier de configuration '[configuration.sh](configuration.sh)'
5. Si la variable d'environnement a bien été valorisé et l'alias également, le programme peut être appelé depuis n'importe
quel emplacement
