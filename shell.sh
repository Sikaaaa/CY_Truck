#!/bin/bash 

#fichier_csv = 'data.csv' # le fichier contenant toutes les données 
nombre_arg=$#


if [ $nombre_arg -eq 0 ] ; then 
    echo "-d1 -> Conducteurs avec le plus de trajets"
    echo "-d2 -> Conducteurs avec la plus grande distance"
    echo "-l -> Les 10 trajets les plus longs"
    echo "-t -> Les 10 villes les plus traversées"
    echo "-s -> Statistiques sur les étapes"

else 
    case "$nombre_arg" in
    #récupérer champs 2 (tout 1) et 6 (trier nom prénom ordre décroissant en prenant le nom) 
    -d1) 
    #faire l'option d1
    cut -d';' -f2,6 data.csv |sort -t' '-k2,2nr| head -10 
    ;;
    -d2)
    #faire l'option d2
    ;;
    -l)
    #faire l'option l
    ;; 
    -t)
    #faire l'option t
    ;;
    -s)
    #faire l'option s
    ;;
    *)
    ;;
    esac
    
    fi



