#!/bin/bash


# Création du message d'aide 
message_h(){
    echo "Pour choisir les options de graphiques il est possible de faire :"
    echo " -d1 pour avoir les 10 conducteurs avec le plus de trajets à leur actif"
    echo " -d2 pour avoir les 10 conducteurs ayant parcouru le plus de kilomètres"
    echo " -l pour avoir les 10 trajets les plus longs"
    echo " -t pour avoir les 10 villes les plus traversées"
    echo " -s pour avoir les différentes statistiques sur les étapes"
}

# Récupérer le premier argument donné 
fichier_de_donnees=$1
shift

if [ "$fichier_de_donnees" == "-h"  ]; then
            #echo "option -h"
            message_h
            exit 0  
fi

# Vérifier qu'il y a au moins une option dans l'appel
if [ "$#" -lt "1" ]; then
    echo "Erreur : nombre d'arguments incorrect"
    echo ""
    message_h
    exit 1
fi 

# Récupérer le chemin absolu du fichier 
CheminExecutable=$(cd `dirname $0`; pwd)


# Récupération des arguments d'appel du script
# ":hd:lts" --> On autorise les options -h, -l, -t, -s ou -d suivi d'un argument 
while getopts ":hd:lts" arg; do
    case ${arg} in

        d) # Les options qui commencent par d et qui doivent avoir un argument supplémentaire
            if [ ${OPTARG} -eq "1" ]; then
                #echo "option -d1"
                faire_d1=true
            elif [ ${OPTARG} -eq "2" ]; then
                #echo "option -d2"
                faire_d2=true
            else
                echo "option -d${OPTARG} invalide"
                message_h
                exit 1
            fi
              
            ;;  

        l) # Le plus de km
            faire_l=true

            ;; 

        t) # Les 10 villes les plus traverséées
            faire_t=true
            ;;

        s) # Statistiques sur les étapes
            faire_s=true
            ;;
        h) # Option -h
            message_h
            exit 0 
            ;;
            
        :) # Test si l'option doit avoir un argument supplémentaire
            echo "ERREUR: l'option -${OPTARG} nécessite un argument."
            message_h 
            exit 1
            ;;

        \?) # Teste si l'option passé en paramètre existe
            echo "ERREUR: Option invalide"
            message_h 
            exit 1
            ;;

    esac
done 

# Récupération du chemin absolu du fichier d'entrée
fichier_de_donnees=$(realpath -s $fichier_de_donnees)

# echo "DEBUG: fichier_de_donnees=$fichier_de_donnees"

# Teste si le fichier passé en paramètre existe
if [ ! -f "$fichier_de_donnees" ]; then
    echo "Erreur: le fichier de données $fichier_de_donnees n'existe pas."
    echo ""
    message_h
    exit 1
fi

# Vérifier si le dossier images existe, sinon le créer
if [ ! -d "$CheminExecutable/images" ]; then
    echo "Création du repertoire $CheminExecutable/images"
    mkdir -p $CheminExecutable/images
fi

# Vérifier si le dossier temp existe et le vider, sinon le créer
if [ -d "$CheminExecutable/temp" ]; then
    # Si le dossier temp existe déjà, il devra le vider avant l’exécution des traitements
    echo "Suppression des fichiers dans le repertoire $CheminExecutable/temp"
    rm -f $CheminExecutable/temp/*.*
else
    echo "Création du repertoire $CheminExecutable/temp"
    mkdir -p $CheminExecutable/temp
fi

# Vérifier si le dossier scriptgnu existe et le vider, sinon le créer
if [ -d "$CheminExecutable/scriptgnu" ]; then
    # Si le dossier scriptgnu existe déjà, il devra le vider avant l’exécution des traitements
    echo "Suppression des fichiers dans le repertoire $CheminExecutable/scriptgnu"
    rm -f $CheminExecutable/scriptgnu/*.gnu
else
    echo "Création du repertoire $CheminExecutable/scriptgnu"
    mkdir -p $CheminExecutable/scriptgnu
fi

# Test si les executables de l'option t existent sinon les créer
if [ ! -f "$CheminExecutable/progc/CY_Truck_t1" ] || [ ! -f "$CheminExecutable/progc/CY_Truck_t2" ]; then
    # Execution du code C qui tri en fonction du nombre de trajet dans l'ordre décroissant      
    cd $CheminExecutable/progc
    make CY_Truck_t
    resultat=$?
    if [ "$resultat" -ne 0 ]; then
        echo "Erreur de compilation des scripts C pour l'option t"
        exit 1
    fi
fi

# Test si les executables de l'option s existent sinon les créer
# if [ ! -f "$CheminExecutable/progc/CY_Truck_s" ]; then
#     cd $CheminExecutable/progc
#     make CY_Truck_s
#     resultat=$?
#     if [ "$resultat" -ne 0 ]; then
#         echo "Erreur de compilation des scripts C pour l'option s"
#         exit 1
#     fi
# fi


if [ "$faire_d1" ]; then 
    # echo "faire option -d1"

    # Création du fichier de configuration gnuplot pour l'option d1
    cat <<EOF > $CheminExecutable/scriptgnu/d1.gnu
# Paramètres du graphique
set terminal png
set xlabel "Conducteurs"
set y2label "Nombre de Trajets"
set ylabel "Les dix meilleurs chauffeurs"

# Nom du fichier dans lequel le graphique apparaîtra
set output "$CheminExecutable/images/Le_plus_de_trajet.png"

# Type de graphique
set style data histograms
set style fill solid
set boxwidth 1.5

# Pour que le graph soit dans le bon sens
set xtics rotate
set ytics rotate
set y2tics rotate
unset ytics; set y2tics mirror
set terminal pngcairo size 1080,1920 enhanced font 'Times New Roman, 13'


# Charger les données depuis le fichier
set datafile separator ','
plot '$CheminExecutable/temp/d1_top_10.csv' using 1:xticlabels(2) axes x1y2 notitle
EOF

    # Récupere l'heure au début de l'exécution
    tmp_d=$(date +%s)
    
    # Récupérer champs 2 (tous égales à 1) et 6 (trier nom prénom ordre décroissant en prenant le nom)
    awk -F';' '$2 == 1 {tab[$6] += 1 }
        END {for (i in tab) printf "%d,%s\n", tab[i],i}' $fichier_de_donnees | sort -n -r -t';' -k1 | head -10  > $CheminExecutable/temp/d1_top_10.csv

    # Récupere l'heure à la fin de l'exécution
    tmp_f=$(date +%s)
            
    # Calcule le temps d'exécution en soustraillant les deux
    echo "Le temps d'execution de l'option -d1 est de" $((tmp_f - tmp_d)) "secondes"

    # Générer le graphique
    gnuplot $CheminExecutable/scriptgnu/d1.gnu
    convert -rotate 90 $CheminExecutable/images/Le_plus_de_trajet.png $CheminExecutable/images/Le_plus_de_trajet1.png
    rm -f $CheminExecutable/images/Le_plus_de_trajet.png

fi

if [ "$faire_d2" ]; then
    #echo "faire option -d2" # Récupérer les 10 conducteurs avec le plus de km au compteur

    # Création du fichier de configuration gnuplot pour l'option d2
    cat <<EOF > $CheminExecutable/scriptgnu/d2.gnu
# Paramètres du graphique
set terminal png
set xlabel "Conducteurs"
set y2label "Nombre de km"
set ylabel "Les conducteurs avec le plus de km au compteur"

# Nom du fichier dans lequel le graphique apparaîtra
set output "$CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png"


# Type de graphique
set style data histograms
set style fill solid
set boxwidth 1.5


# Pour que le graph soit dans le bon sens
set xtics rotate
set ytics rotate
set y2tics rotate
unset ytics; set y2tics mirror
set terminal pngcairo size 1080,1920 enhanced font 'Times New Roman, 13'


# Charger les données depuis le fichier
set datafile separator ','
plot '$CheminExecutable/temp/d2_top_10.csv' using 1:xticlabels(2) axes x1y2 notitle
EOF

    # Récupérer de début de l'exécution
    tmp_d=$(date +%s)
    
    # Création d'un tableau par nom de conducteur et addition des kms parcourus par chacun
    awk -F';' '{tab[$6] += $5}
       END {for (i in tab) printf "%d,%s\n", tab[i],i}' $fichier_de_donnees | sort -n -r -t';' -k1 | head -10 > $CheminExecutable/temp/d2_top_10.csv  
       
    # Récupere l'heure à la fin de l'exécution
    tmp_f=$(date +%s)
       
    # Calcule le temps d'exécution en soustraillant les deux
    echo "Le temps d'execution de l'option -d2 est de" $((tmp_f - tmp_d)) "secondes"
       
    # Générer le graphique
    gnuplot $CheminExecutable/scriptgnu/d2.gnu 
    convert -rotate 90 $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km1.png  
    rm -f $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png

fi

if [ "$faire_l" ]; then
    #echo "faire option -l"     # Les 10 trajets les plus longs

    # Création du fichier de configuration gnuplot pour l'option l
    cat <<EOF > $CheminExecutable/scriptgnu/l.gnu
#Paramètres du graphique
set terminal pngcairo size 1920,1080 enhanced font 'Times New Roman, 13'
set title "Les 10 trajets les plus longs"
set ylabel "Distance en km"
set xlabel "Id Route"

#nom du fichier dans lequel le graphique apparaitra 
set output "/$CheminExecutable/images/Les_10_trajets_les_plus_longs.png" 

# Type de graphique
set style fill solid
set boxwidth 0.5
set size 1,1
set border lc rgb 'black'
set boxwidth 0.5 relativ

# Plages des axes x et y
set yrange [0:3000]
set xrange [*:*]

# Charger les données depuis le fichier
set datafile separator ','
plot '$CheminExecutable/temp/l_trajet_plus_long.csv' using (2*\$0+1):2:xticlabels(1) title "Distance" with boxes
EOF

    # Récupere l'heure au début de l'exécution
    tmp_d=$(date +%s)

    # Récupérer la somme de chaque étape 
    awk -F';' '{tab[$1] += $5}
        END {for (i in tab) printf "%d,%d\n", i,tab[i]}' $fichier_de_donnees | sort -n -r -t',' -k2 | head -10 | sort -n -t',' -k1 > $CheminExecutable/temp/l_trajet_plus_long.csv 

    # Récupere l'heure à la fin de l'exécution
    tmp_f=$(date +%s)

    # Calcule le temps d'exécution en soustraillant les deux
    echo "Le temps d'execution de l'option -l est de" $((tmp_f - tmp_d)) "secondes"

    # Générer le graphique
    gnuplot $CheminExecutable/scriptgnu/l.gnu 
fi


if [ "$faire_t" ]; then 
    #echo "faire option -t"

    # Création du fichier de configuration gnuplot pour l'option t
    cat <<EOF > $CheminExecutable/scriptgnu/t.gnu
#Pramètres du graphique
set terminal pngcairo size 1920,1080 enhanced font 'Times New Roman, 13'
set title 'Les_10_villes_les_plus_traversées'
set xlabel "Noms de villes"
set ylabel "Nombre de routes"

#nom du fichier dans lequel le graphique apparaitra 
set output "$CheminExecutable/images/Les_10_villes_les_plus_traversées.png"

#type de graphique 
set style data histograms 
set style fill solid border -1
set boxwidth 0.8 relative
set key autotitle columnheader
set boxwidth 1.3 relative

#charger les données dans le fichier puis générer le graph
set datafile separator ','
plot '$CheminExecutable/temp/t_top_10.csv' using 2:xtic(1) title columnheader, '' using 3 title columnheader
EOF

    # Récupere l'heure au début de l'exécution
    tmp_d=$(date +%s)
            
    # On compte le nombre de fois où une ville est traversée  
    awk -F";" 'NR > 1 {tab[$1";"$4] +=1; if ($2==1) {tab[$1";"$3]+=1; deb[$1";"$3]=1}} END {for (ville in tab) print ville ";" tab[ville] ";" deb[ville] }' $fichier_de_donnees | awk -F";" '{tab[$2]+=1; deb[$2]+=$4} END {for (ville in tab) print ville "," tab[ville] "," deb[ville]}' > $CheminExecutable/temp/t_tri.csv 

    # Appel de l'exécutable de la fonction Fonction_t qui trie dans l'ordre décroissant les données en entrée
    $CheminExecutable/progc/CY_Truck_t1 $CheminExecutable/temp/t_tri.csv > $CheminExecutable/temp/t_top_non_trie.csv 
    resultat=$?
    if [ "$resultat" -ne 0 ]; then
        echo "Erreur d'execution de la fonction CY_Truck_t1"
        exit 1
    fi

    # Appel de l'exécutable de la fonction Tri_nom qui tri en fonction des noms de villes dans l'ordre alphabétique
    $CheminExecutable/progc/CY_Truck_t2 $CheminExecutable/temp/t_top_non_trie.csv > $CheminExecutable/temp/t_top_10.csv
    resultat=$?
    if [ "$resultat" -ne 0 ]; then
        echo "Erreur d'execution de la fonction CY_Truck_t2"
        exit 1
    fi 

    # Récupere l'heure à la fin de l'exécution
    tmp_f=$(date +%s)

    # Calcule le temps d'exécution en soustraillant les deux
    echo "Le temps d'execution de l'option -t est de" $((tmp_f - tmp_d)) "secondes"
    gnuplot $CheminExecutable/scriptgnu/t.gnu
fi


if [ "$faire_s" ]; then 
    echo "faire option -s"
    # A finaliser

fi