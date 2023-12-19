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
    awk -F';' '$2 == 1 {tab[$6] += 1 }
        END {for (i in tab) printf "%d, %s \n", tab[i],i}' ./data/data.csv > ./temp/d1_tableau.csv

    sort -n -r -t';' -k1 ./temp/d1_tableau.csv > ./temp/d1_tri.csv
    head -10 ./temp/d1_tri.csv > ./data/d1_top_10.csv

    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)

    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"
    ;;

    '-d2')
    #faire l'option d2
    ;;

    '-l')
    # Récupere l'heure au début de l'exe
    tmp_d=$(date +%s)
    
    #récupérer somme chaque étape 
    awk -F';' '{tab[$1] += $5} 
        END {for (i in tab) printf "%d, %d \n", i,tab[i]}' ./data/data.csv > ./temp/l_tableau.csv
        
    sort -n -r -t',' -k2 ./temp/l_tableau.csv > ./temp/l_tri.csv
    head -10 ./temp/l_tri.csv > ./temp/l_tri2.csv
    sort -n -t',' -k1 ./temp/l_tri2.csv > ./data/l_trajet_plus_long.csv

    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)

    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"

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



