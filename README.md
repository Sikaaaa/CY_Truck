## Sommaire
- [Contenu](#contenu) Expliquer ce qu'est le projet ainsi que ses fonctionnalités
- [Objectif](#objectif) Expliquer le but de ce projet
- [Groupe](#groupe) Les membres du groupe 
- [Fichiers](#fichiers) Quels sont les fichiers et leurs fonctions
- [Compiler](#compiler) Comment compiler le projet
- [Prérequis](#prérequis) Les bibliothèques à installer 
- [Utilisation_de_l'application](#utilisation_de_l'application) Comment utiliser l'application
- [Livraison_du_Projet](#livraison_du_Projet) Forme du rendu
- [Répartition](#répartition) Répartition des tâches parmis les membres du groupe
- [Sources](#sources) Les ressources sur lesquelles nous nous sommes basées



## Contenu

Ce projet consiste à développer une solution complète pour analyser de grandes quantités de données logistiques de transport pour une entreprise nationale de transport routier. L'objectif est de créer un script en Shell et un programme C correspondant pour traiter et générer des informations consolidées à partir du fichier de données CSV fourni.
  
  
## Objectif 

Le but de ce projet est de faire des tris à partir des données d'une entreprise. De là nous avons plusieurs options qui nous permettes de représenter ces tris sous formes de graphiques.
  
  
## Groupe 

Notre groupe est composé d'Orianne COURTADE, Héloïse DEY et Maellys AMAINI  
En cas de questions, de commentaires et ou de problemes vous pouvez contacter les auteurs du programmes.  
  
amainimaellys@cy-tech.fr  
deyheloise@cy-tech.fr  
courtadeor@cy-tech.fr  
  

## Fichiers

	- data 		:Le dossier contenant le fichier CSV avec les données des trajets
	- progc 	:Le dossier contenant le programme C et le Makefile
	- images	:Le dossier où seront stockées les images générées
	- temp 		:Le dossier pour les fichiers intermédiaires
	- demo 		:Le dossier pour stocker les résultats d'exécutions précédentes
	- script.sh 	:Le script shell principal
	- README.md 	:Ce fichier
  
Le Script Shell:
  
Il est situé à la racine du projet et il vérifie la présence de l'exécutable C, le compile si nécessaire et effectue le traitement des données en fonction des options. Il gère la création et le nettoyage des répertoires nécessaires et produit des représentations graphiques des données traitées à l'aide de Gnuplot.  
  
Les Fichiers de Données :  
  
Le Fichier de données CSV d'entrée se nomme 'data.csv', il est composé des informations détaillées sur les trajets routiers. Les fichiers résultats, les fichiers intermédiaires et images stockés dans le répertoire 'demo'. Les fichiers temporaires dans 'temp'. Les graphiques dans 'images'.  
  
Les Fonctionnalités du Programme C:  
  
Il se concentre sur le filtrage, le tri et les calculs des données en obeissantt au script Shell. 
  
  
## Compiler 

Assurez-vous d'avoir le compilateur GCC installé.  
La compilation se fait a travers du fichier Makefile se trouvant dans le répertoire progc.
Il est possible de nettoyer manuellement ce répertoire en utilisant la commande suivante:
```
cd progc/
make clean
```
  

## Prérequis
  
Afin d'installer toutes les bibliothèques nécessaires il faut exécuter cette commande sous linux:

```
sudo apt-get install gnuplot imagemagick
```
  

## Utilisation_de_l'application
  
Une fois le projet github récupéré sur le PC, vous devez utiliser la commande suivante pour rendre le script shell exécutable:
```
chmod 755 Traitement.sh
```
  
Vous pouvez utilsier la commande suivante pour afficher l'aide:
```
./Traitement.sh -h
``` 
  

## Livraison_du_Projet
  
- Nous avons utlisé un dépôt GitHub pour la soumission du projet 
- Mises à jour fréquentes, au moins deux fois par semaine du dépôt 
- Un fichier ReadMe contenant des instructions de compilation et d'utilisation  
- Exemples des résultats de l'exécution du script dans le répertoire 'demo' 
  

## Répartition 
  
Voir PDF
  

## Sources 
  
Gnuplot  
http://gnuplot.info/  
Gestion des paramètres en bash  
https://debian-facile.org/utilisateurs:david5647:tutos:bash-gerer-les-parametres  
AWK  
https://www.funix.org/fr/unix/awk.htm  
  

# CY_Tech
  
![CYTECH](https://github.com/Sikaaaa/CY_Truck/blob/main/CY_Tech_logo.jpg)

