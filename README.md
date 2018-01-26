# lbp.toolsfordev.scripts

Provides scripts to use with git or command line

## Usage :
Dans un invité de commande Bash (celui installé avec GIT par exemple), taper :
* Si emplacement du programme renseigné dans un alias :
```bash
lbp nomScript [arg1] [arg2] ... [argN]
```

## Scripts disponibles :

Plus d'informations dans chaque script ou en éxécutant un script avec l'argument --help (pas de -h car conflit)

Pour faire remonter des bugs ou si vous imaginez des améliorations ou ajouts, envoyez un mail à 'florian.castera@accenture.com'. Merci


#####Name : branch.sh
Appel : lbp branch/gbr <br>
Description : Permet de passer à la branche passé en paramètre <br>
Arguments : <br>
*  Pas d'arguments <br>

#####Name : clean.sh
Appel : lbp clean/cl <br>
Description : Permet de nettoyer le projet des fichiers résiduels (*.bak, *.log, *.orig, ...) <br>
Arguments : <br>
*  --detail/-d : Affiche tous les fichiers supprimés de façon exhaustive <br>

#####Name : clone.sh
Appel : lbp clone/gcl <br>
Description : Permet de cloner les dépots présents dans repositories.txt (décommenter les lignes voulues en supprimant les --) <br>
Arguments : <br>
*  --force/-f  : Supprime les répertoires existants et fait un clone <br>

#####Name : command.sh
Appel : lbp command/cmd <br>
Description : Permet d'exécuter une commande dans tous les projets <br>
Arguments : <br>
*  Pas d'arguments <br>

#####Name : framework.sh
Appel : lbp framework/fw <br>
Description : Permet d'afficher ou de mettre à jour les versions des frameworks <br>
Arguments : <br>
*  --update/-u : permet de mettre à jour les frameworks (ex : --update/-u fwad 4.5.5) <br>

#####Name : grunt.sh
Appel : lbp grunt/grt <br>
Description : Permet d'exécuter des tâches Grunt dans tous les projets (sauf watch) <br>
Arguments : <br>
*  --all/-a    : Permet d'exécuter toutes les tâches communes (browserify et cssmin) <br>
*  --detail/-d : Affiche la sortie de grunt dans la console <br>

#####Name : merge.sh
Appel : lbp merge/gbm <br>
Description : Permet de merger la branche passé en paramètre dans la branche étudiée <br>
Arguments : <br>
*  Pas d'arguments <br>

#####Name : npm.sh
Appel : lbp npm/np <br>
Description : Permet d'exécuter des tâches npm dans tous les projets <br>
Arguments : <br>
*  Pas d'arguments <br>

#####Name : pom.sh
Appel : lbp pom/pm <br>
Description : Permet de dresser la liste des versions des pom.xml, ainsi que les dépendances <br>
Arguments : <br>
*  --all/-a        : Permet d'afficher les dépendances pour chaque projet <br>
*  --sync/-s       : Permet de synchroniser les verions des dépendances avec les pom.xml des projects locaux <br>
*  --increment/-i  : Permet d'incrémenter de 1 la version de tous les poms (--snapshot pour ajouter le suffixe -SNAPSHOT) <br>

#####Name : pull.sh
Appel : lbp pull/gpl <br>
Description : Permet de mettre à jour le dépot local sur la branche active à partir du dépot distant. Les fichiers mergés seront proposés à la fin du programme <br>
Arguments : <br>
*  --stash/-s  : Permet de faire un git stash avant le pull, puis de faire un git stash pop après <br>
*  --detail/-d : Permet d'afficher toutes les sorties de la commande git pull <br>

#####Name : status.sh
Appel : lbp status/gst <br>
Description : Permet de dresser la liste des fichiers modifiés de la même manière que la commande git status <br>
Arguments : <br>
*  --hide/-h   : Permet de cacher les fichiers à ne pas commiter (AccreditationService, SecurityBouchonConfig, pom.xml, ...) <br>
*  --update/-u : Permet de rafraichir le dépôt local et indique s'il est à jour ou derrière/devant le dépot distant <br>
*  --branch/-b : Permet d'afficher la branche courante <br>

#####Name : uid.sh
Appel : lbp userId/uid <br>
Description : Permet de modifier le code conseiller dans les fichiers SecurityBouchonConfig.xml <br>
Arguments : <br>
*  --list/-l   : Permet d'afficher tous les codes conseillers sans les modifier <br>

#####Name : urls.sh
Appel : lbp urls/ur <br>
Description : Permet d'afficher ou modifier les urls d'assemblages dans les gcp <br>
Arguments : <br>
*  Pas d'arguments <br>
