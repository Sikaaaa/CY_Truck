#!/bin/bash


# Vérification de l'existence du dossier images
if test -d "images"; then
    rm -r images
fi
mkdir images
# Vérification de l'existence du dossier temp
if test -d "temp"; then
    rm -r temp
fi
mkdir temp

message_h(){
    echo "Pour choisir les options de graphiques il est possible de faire :"
    echo " -d1 pour avoir les 10 conducteurs avec le plus de trajets à leur actif"
    echo " -d2 pour avoir les 10 conducteurs ayant parcouru le plus de kilomètres"
    echo " -l pour avoir les 10 trajets les plus longs"
    echo " -t pour avoir les 10 villes les plus traversées"
    echo " -s pour avoir les différentes statistiques sur les étapes"
}

#récupérer le premier argument donné 
fichier_de_donnees=$1
shift

if [ "$fichier_de_donnees" == "-h"  ]; then
            #echo "option -h"
            message_h
            exit 0  
fi

#Récupérer le chemin absolu du fichier 
CheminExecutable=$(cd `dirname $0`; pwd)


nombre_arg=$*
while getopts ":hd:lts" arg; do
    case ${arg} in

        '-d1') #récupérer les 10 conducteurs avec le plus de trajets 
            # Récupere l'heure au début de l'exe
            tmp_d=$(date +%s)
    
            # récupérer champs 2 (tout 1) et 6 (trier nom prénom ordre décroissant en prenant le nom)
            awk -F';' '$2 == 1 {tab[$6] += 1 }
                END {for (i in tab) printf "%d,%s\n", tab[i],i}' $CheminExecutable/data.csv | sort -n -r -t';' -k1 | head -10  > $execPath/d1_top_10.csv

            # Récupere l'heure à la fin de l'exe
            tmp_f=$(date +%s)

            # Calcule le temps d'exe en soustraillant les deux
            echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"

            #générer le graphique
            gnuplot d1.gnu
            convert -rotate 90 $CheminExecutable/images/Le_plus_de_trajet.png $CheminExecutable/images/Le_plus_de_trajet1.png
            rm -f $CheminExecutable/images/Le_plus_de_trajet.png
        ;;

        '-d2') #Récupérer les 10 conducteurs avec le plus de km au compteur

            # Récupere l'heure au début de l'exe
            tmp_d=$(date +%s)
       
            awk -F';' '{tab[$6] += $5}
               END {for (i in tab) printf "%d,%s\n", tab[i],i}' ./data/data.csv | sort -n -r -t';' -k1 | head -10 > ./demo/d2_top_10.csv
       
            # Récupere l'heure à la fin de l'exe
            tmp_f=$(date +%s)
       
            # Calcule le temps d'exe en soustraillant les deux
            echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"
       
            # générer le graphique
            gnuplot d2.gnu
            convert -rotate 90 $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km1.png  
            rm -f $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png
        ;;

        '-l') # les 10 trajets les plus longs

            # Récupere l'heure au début de l'exe
            tmp_d=$(date +%s)

            #récupérer somme chaque étape 
            awk -F';' '{tab[$1] += $5}
                END {for (i in tab) printf "%d,%d\n", i,tab[i]}' $CheminExecutable/data/data.csv | sort -n -r -t',' -k2 | head -10 | sort -n -t',' -k1 > $CheminExecutable/data/l_trajet_plus_long.csv

            # Récupere l'heure à la fin de l'exe
            tmp_f=$(date +%s)

            # Calcule le temps d'exe en soustraillant les deux
            echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"

            #générer le graphique
            gnuplot l.gnu
        ;; 

        '-t')
        #faire l'option t
        ;;

        '-s')
        #faire l'option s
        ;;


        *)
            echo "voir quoi mettre"
        ;;

    esac
done 

if [ ! -f "$fichier_de_donnees" ]; then
    echo "Erreur: le fichier de données $fichier_de_donnees n'existe pas."
    echo ""
    message_aide
    exit 1
fi
    



