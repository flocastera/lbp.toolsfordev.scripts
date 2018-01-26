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


### branch.sh
_Appel_ : lbp branch/gbr <br>
_Description_ : Permet de passer à la branche passé en paramètre <br>
_Arguments_ : <br>
*  Pas d'arguments <br>

### clean.sh
_Appel_ : lbp clean/cl <br>
_Description_ : Permet de nettoyer le projet des fichiers résiduels (*.bak, *.log, *.orig, ...) <br>
_Arguments_ : <br>
*  --detail/-d : Affiche tous les fichiers supprimés de façon exhaustive <br>

### clone.sh
_Appel_ : lbp clone/gcl <br>
_Description_ : Permet de cloner les dépots présents dans repositories.txt (décommenter les lignes voulues en supprimant les '--') <br>
_Arguments_ : <br>
*  --force/-f  : Supprime les répertoires existants et fait un clone <br>

### command.sh
_Appel_ : lbp command/cmd <br>
_Description_ : Permet d'exécuter une commande dans tous les projets <br>
_Arguments_ : <br>
*  Pas d'arguments <br>

### framework.sh
_Appel_ : lbp framework/fw <br>
_Description_ : Permet d'afficher ou de mettre à jour les versions des frameworks <br>
_Arguments_ : <br>
*  --update/-u : permet de mettre à jour les frameworks (ex : --update/-u fwad 4.5.5) <br>

### grunt.sh
_Appel_ : lbp grunt/grt <br>
_Description_ : Permet d'exécuter des tâches Grunt dans tous les projets (sauf watch) <br>
_Arguments_ : <br>
*  --all/-a    : Permet d'exécuter toutes les tâches communes (browserify et cssmin) <br>
*  --detail/-d : Affiche la sortie de grunt dans la console <br>

### merge.sh
_Appel_ : lbp merge/gbm <br>
_Description_ : Permet de merger la branche passé en paramètre dans la branche étudiée <br>
_Arguments_ : <br>
*  Pas d'arguments <br>

### npm.sh
_Appel_ : lbp npm/np <br>
_Description_ : Permet d'exécuter des tâches npm dans tous les projets <br>
_Arguments_ : <br>
*  Pas d'arguments <br>

### pom.sh
_Appel_ : lbp pom/pm <br>
_Description_ : Permet de dresser la liste des versions des pom.xml, ainsi que les dépendances <br>
_Arguments_ : <br>
*  --all/-a        : Permet d'afficher les dépendances pour chaque projet <br>
*  --sync/-s       : Permet de synchroniser les verions des dépendances avec les pom.xml des projects locaux <br>
*  --increment/-i  : Permet d'incrémenter de 1 la version de tous les poms (--snapshot pour ajouter le suffixe -SNAPSHOT) <br>

### pull.sh
_Appel_ : lbp pull/gpl <br>
_Description_ : Permet de mettre à jour le dépot local sur la branche active à partir du dépot distant. Les fichiers mergés seront proposés à la fin du programme <br>
_Arguments_ : <br>
*  --stash/-s  : Permet de faire un git stash avant le pull, puis de faire un git stash pop après <br>
*  --detail/-d : Permet d'afficher toutes les sorties de la commande git pull <br>

### status.sh
_Appel_ : lbp status/gst <br>
_Description_ : Permet de dresser la liste des fichiers modifiés de la même manière que la commande git status <br>
_Arguments_ : <br>
*  --hide/-h   : Permet de cacher les fichiers à ne pas commiter (AccreditationService, SecurityBouchonConfig, pom.xml, ...) <br>
*  --update/-u : Permet de rafraichir le dépôt local et indique s'il est à jour ou derrière/devant le dépot distant <br>
*  --branch/-b : Permet d'afficher la branche courante <br>

### uid.sh
_Appel_ : lbp userId/uid <br>
_Description_ : Permet de modifier le code conseiller dans les fichiers SecurityBouchonConfig.xml <br>
_Arguments_ : <br>
*  --list/-l   : Permet d'afficher tous les codes conseillers sans les modifier <br>

### urls.sh
_Appel_ : lbp urls/ur <br>
_Description_ : Permet d'afficher ou modifier les urls d'assemblages dans les gcp <br>
_Arguments_ : <br>
*  Pas d'arguments <br>
