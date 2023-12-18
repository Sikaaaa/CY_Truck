#!/bin/bash 

#fichier_csv = 'data.csv' # le fichier contenant toutes les données 
nombre_arg=$*



if [ -z $nombre_arg ] ; then 
    echo "-d1 -> Conducteurs avec le plus de trajets"
    echo "-d2 -> Conducteurs avec la plus grande distance"
    echo "-l -> Les 10 trajets les plus longs"
    echo "-t -> Les 10 villes les plus traversées"
    echo "-s -> Statistiques sur les étapes"

else 
    case $nombre_arg in
    '-d1') #option top 10 
    # Récupere l'heure au début de l'exe
    tmp_d=$(date +%s)
    
    #récupérer champs 2 (tout 1) et 6 (trier nom prénom ordre décroissant en prenant le nom) 
    awk -F';' '$2 == 1 {printf "%s \n", $6}' data.csv > ./d1_top_10.csv
    
    #cut -d';' -f2,6 data.csv |sort -t' '-k2,2nr| head -10 > top_10.csv

    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)

    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d))
    ;;

    '-d2')
    #faire l'option d2
    ;;
    '-l')
    # Récupere l'heure au début de l'exe
    tmp_d=$(date +%s)
    
    #récupérer somme chaque étape 
    awk -F';' '{printf "%s, %s, %s \n", $1, $2, $5}' data.csv > ./l_top_10.csv

    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)

    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de " $((tmp_f - tmp_d))

    ;; 
    '-t')
    #faire l'option t
    ;;
    '-s')
    #faire l'option s
    ;;
    *)
    echo "bla bla"
    ;;
    esac
    
    fi



