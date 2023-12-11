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
    case [ $nombre_arg -eq 1 ] 
    #récupérer champs 2 (tout 1) et 6 (trier nom prénom ordre décroissant en prenant le nom) 
    case [ $nombre_arg -eq 2 ]
    #faire l'option d2
    case [ $nombre_arg -eq 3 ]
    #faire l'option l
    case [ $nombre_arg -eq 4 ]
    #faire l'option t
    case [ $nombre_arg -eq 5 ]
    #faire l'option s

    fi



