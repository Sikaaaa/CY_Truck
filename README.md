Bienvenue dans notre projet CY-Trucks!

Ce projet consiste à développer une solution complète pour analyser de grandes quantités de données logistiques de transport pour une entreprise nationale de transport routier. L'objectif est de créer un script en Shell et un programme C correspondant pour traiter et générer des informations consolidées à partir du fichier de données CSV fourni.


Auteurs: 

	Maellys Amaini
	Heloïse Dey
	Orianne Coutarde 

	En cas de questions, de commentaires et ou de problemes vous pouvez contacter les auteurs du programmes.

 	amainimaellys@cy-tech.fr
 	deyheloise@cy-tech.fr
 	courtadeor@cy-tech.fr


Le contenu du Projet
	- data 	:Le dossier contenant le fichier CSV avec les données des trajets.
	- progc 	:LE dossier contenant le programme C et le Makefile.
	- images	:LE dossier où seront stockées les images générées.
	- temp 	:Le dossier pour les fichiers intermédiaires.
	- demo 	:LE dossier pour stocker les résultats d'exécutions précédentes.
	- script.sh 	:Le script shell principal.
	- README.md 	:Ce fichier


Le Script Shell:
	Il est situé à la racine du projet et il vérifie la présence de l'exécutable C, le compile si nécessaire et effectue le traitement des données en fonction des option. Il gère la création et le nettoyage des répertoires nécessaires et produit des représentations graphiques des données traitées à l'aide de Gnuplot.





Les Fichiers de Données :

  Le Fichier de données CSV d'entrée se nome 'data.csv', il est composé des informations détaillées sur les trajets routiers.

  Les fichiers résultats, les fichiers intermédiaires et images stockés dans le répertoire 'demo'.

  LEs fichiers temporaires dans 'temp'.
  
  Les graphiques dans 'images'.




Les Fonctionnalités du Programme C:

	Il se concentre sur le filtrage, le tri et les calculs des données en obeissantt au script Shell.






Livraison du Projet:

	- Nous avons utlisés un dépôt GitHub pour la soumission du projet.

	- Mises à jour fréquentes au moins deux fois par semaine du dépôt.

	- Un fichier ReadMe contenant des instructions de compilation et d'utilisation.

	- Exemples des résultats de l'exécution du script dans le répertoire 'demo'.





Notes Importantes:



Prérequis :

	#Ce dont l'utlisateur a besoin pour executer notre projet




Instructions d'Utilisation :

	Assurez-vous d'avoir le compilateur GCC installé.
	La compilation se fait a travers du fichier Makefile se trouvant dans le répertoire progc. Il est possible de nettoyer manuellement ce répertoire en utilisant la commande suivante:

	cd progc/
	make clean
	

Utilisation de l'application:

	Une fois le projet github récupéré sur le PC, vous devez utiliser la commande suivante pour rendre le script shell exécutable:

	chmod 755 Traitement.sh

	Vous pouvez utilsier la commande suivante pour afficher l'aide:

.	/Traitement.sh -h



Exemples d'Exécution :







Contribution :

	option l terminée (Héloïse/Orianne) voir les "petits trucs" (-h, temps d'exec, etc..)



Historique des Versions :

    


La liste des problèmes connus :



Fonctionnalités Bonus:


Sources:

	gnuplot
	sources: gestion des paramètres en bash
	https://debian-facile.org/utilisateurs:david5647:tutos:bash-gerer-les-parametres 
	https://www.funix.org/fr/unix/awk.htm

