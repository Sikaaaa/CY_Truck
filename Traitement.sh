#!/bin/bash


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

#vérifier qu'il y a au moins une option dans l'appel
if [ "$#" -lt "1" ]; then
    echo "Erreur : nombre d'arguments incorrect"
    echo ""
    message_h
    exit 1
fi 

#Récupérer le chemin absolu du fichier 
CheminExecutable=$(cd `dirname $0`; pwd)


nombre_arg=$*
while getopts ":hd:lts" arg; do
    case ${arg} in

        d) #les options qui commencent par d
            if [ ${OPTARG} -eq "1" ]; then
                echo "option -d1"
                faire_d1=true
            elif [ ${OPTARG} -eq "2" ]; then
                echo "option -d2"
                faire_d2=true
            else
                echo "option -d${OPTARG} invalide"
                message_h
                exit 1
            fi
              
            ;;  

        l) # le plus de km
            faire_l=true

            ;; 

        t)
            faire_t=true
            ;;

        s)
            faire_s=true
            ;;
        h) 
            message_h
            exit 1
            ;;
            
        :)
            echo "ERREUR: l'option -${OPTARG} nécessite un argument."
                message_h
                exit 1
            ;;

        \?)
            echo "ERREUR: Option invalide"
            message_aide
            exit 1
            ;;

    esac
done 

if [ ! -f "$fichier_de_donnees" ]; then
    echo "Erreur: le fichier de données $fichier_de_donnees n'existe pas."
    echo ""
    message_h
    exit 1
fi

#vérifier si le dossier images existe, sinon le créer
if [ ! -d "$CheminExecutable/images" ]; then
    echo "Création du repertoire $CheminExecutable/images"
    mkdir -p $CheminExecutable/images
fi

#vérifier si le dossier temp existe, sinon le créer
if [ -d "$CheminExecutable/temp" ]; then
    # Si le dossier temp existe déjà, il devra le vider avant l’exécution des traitements
    echo "Suppression des fichiers dans le repertoire $CheminExecutable/temp"
    rm -f $CheminExecutable/temp/.
else
    echo "Création du repertoire $CheminExecutable/temp"
    mkdir -p $CheminExecutable/temp
fi

if [ "$faire_d1" ]; then 
    # Récupere l'heure au début de l'exe
    echo "faire option d1"
    tmp_d=$(date +%s)
    
    # récupérer champs 2 (tout 1) et 6 (trier nom prénom ordre décroissant en prenant le nom)
    awk -F';' '$2 == 1 {tab[$6] += 1 }
        END {for (i in tab) printf "%d,%s\n", tab[i],i}' $CheminExecutable/data/data.csv | sort -n -r -t';' -k1 | head -10  > $CheminExecutable/data/d1_top_10.csv

    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)
            
    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"

    #générer le graphique
    gnuplot $CheminExecutable/d1.gnu
    convert -rotate 90 $CheminExecutable/images/Le_plus_de_trajet.png $CheminExecutable/images/Le_plus_de_trajet1.png
    rm -f $CheminExecutable/images/Le_plus_de_trajet.png

fi

if [ "$faire_d2" ]; then
    echo "option d2" #Récupérer les 10 conducteurs avec le plus de km au compteur

    # Récupere l'heure au début de l'exe
    tmp_d=$(date +%s)
       
    awk -F';' '{tab[$6] += $5}
       END {for (i in tab) printf "%d,%s\n", tab[i],i}' $CheminExecutable/data/data.csv | sort -n -r -t';' -k1 | head -10 > $CheminExecutable/data/d2_top_10.csv
       
    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)
       
    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"
       
    # générer le graphique
    gnuplot $CheminExecutable/d2.gnu
    convert -rotate 90 $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km1.png  
    rm -f $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png

fi

if [ "$faire_l" ]; then
    echo "option l"     # les 10 trajets les plus longs

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
    gnuplot $CheminExecutable/l.gnu

fi
