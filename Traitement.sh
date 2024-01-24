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
            echo "option -h"
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
            exit 0
            ;;
            
        :)
            echo "ERREUR: l'option -${OPTARG} nécessite un argument."
            message_h
            exit 1
            ;;

        \?)
            echo "ERREUR: Option invalide"
            message_h
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
    rm -f $CheminExecutable/temp/*.*
else
    echo "Création du repertoire $CheminExecutable/temp"
    mkdir -p $CheminExecutable/temp
fi

#vérifier si le dossier scriptgnu existe, sinon le créer
if [ ! -d "$CheminExecutable/scriptgnu" ]; then
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

# if [ ! -f "$CheminExecutable/progc/CY_Truck_s" ]; then
#     # Execution du code C qui tri en fonction du nombre de trajet dans l'ordre décroissant      
#     cd $CheminExecutable/progc
#     make CY_Truck_s
#     resultat=$?
#     if [ "$resultat" -ne 0 ]; then
#         echo "Erreur de compilation des scripts C pour l'option s"
#         exit 1
#     fi
# fi


if [ "$faire_d1" ]; then 
    echo "faire option d1"

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
plot '$CheminExecutable/data/d1_top_10.csv' using 1:xticlabels(2) axes x1y2 notitle
EOF

    # Récupere l'heure au début de l'exe
    tmp_d=$(date +%s)
    
    # récupérer champs 2 (tout 1) et 6 (trier nom prénom ordre décroissant en prenant le nom)
    awk -F';' '$2 == 1 {tab[$6] += 1 }
        END {for (i in tab) printf "%d,%s\n", tab[i],i}' $fichier_de_donnees | sort -n -r -t';' -k1 | head -10  > $CheminExecutable/data/d1_top_10.csv

    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)
            
    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"

    #générer le graphique
    gnuplot $CheminExecutable/scriptgnu/d1.gnu
    convert -rotate 90 $CheminExecutable/images/Le_plus_de_trajet.png $CheminExecutable/images/Le_plus_de_trajet1.png
    rm -f $CheminExecutable/images/Le_plus_de_trajet.png

fi

if [ "$faire_d2" ]; then
    echo "option d2" #Récupérer les 10 conducteurs avec le plus de km au compteur
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
plot '$CheminExecutable/demo/d2_top_10.csv' using 1:xticlabels(2) axes x1y2 notitle
EOF


    tmp_d=$(date +%s)
       
    awk -F';' '{tab[$6] += $5}
       END {for (i in tab) printf "%d,%s\n", tab[i],i}' $fichier_de_donnees | sort -n -r -t';' -k1 | head -10 > $CheminExecutable/data/d2_top_10.csv
    
    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)
       
    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"
       
    # générer le graphique
    gnuplot $CheminExecutable/scriptgnu/d2.gnu
    convert -rotate 90 $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km1.png  
    rm -f $CheminExecutable/images/Les_conducteurs_avec_le_plus_de_km.png

fi

if [ "$faire_l" ]; then
    echo "option l"     # les 10 trajets les plus longs

    cat <<EOF > $CheminExecutable/scriptgnu/l.gnu

#Paramètres du graphique
set terminal pngcairo size 1920,1080 enhanced font 'Times New Roman, 13'
set title "Les 10 trajets les plus longs"
set ylabel "Distance en km"
set xlabel "Id Route"

#nom du fichier dans lequel le graphique apparaitra 
set output "/$CheminExecutable/images/Les 10 trajets les plus longs.png" 

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
plot $CheminExecutable/data/l_trajet_plus_long.csv' using (2*$0+1):2:xticlabels(1) title "Distance" with boxes
EOF

    # Récupere l'heure au début de l'exe
    tmp_d=$(date +%s)

    #récupérer somme chaque étape 
    awk -F';' '{tab[$1] += $5}
        END {for (i in tab) printf "%d,%d\n", i,tab[i]}' $fichier_de_donnees | sort -n -r -t',' -k2 | head -10 | sort -n -t',' -k1 > $CheminExecutable/data/l_trajet_plus_long.csv

    # Récupere l'heure à la fin de l'exe
    tmp_f=$(date +%s)

    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"

    #générer le graphique
    gnuplot $CheminExecutable/scriptgnu/l.gnu

fi

if [ -n "$faire_t" ]; then 
    echo "option_t"

    car <<EOF > $CheminExecutable/scriptgnu/t.gnu
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
plot '$CheminExecutable/data/t_top_10.csv' using 2:xtic(1) title columnheader, '' using 3 title columnheader
EOF

    # Récupere l'heure au début de l'exe
    tmp_d=$(date +%s)
            
    #récupérer somme chaque étape 
    # On n'a pas fait le cas de la ville de départ, compter le nombre de fois ou il est ville de départrajouter une colonne !  
    awk -F";" 'NR > 1 {tab[$1";"$4] +=1; if ($2==1) {tab[$1";"$3]+=1; deb[$1";"$3]=1}} END {for (ville in tab) print ville ";" tab[ville] ";" deb[ville] }' $fichier_de_donnees | awk -F";" '{tab[$2]+=1; deb[$2]+=$4} END {for (ville in tab) print ville ";" tab[ville] ";" deb[ville]}' > $CheminExecutable/temp/t_tri.csv #oc


    $CheminExecutable/progc/CY_Truck_t1 $CheminExecutable/temp/t_tri.csv > $CheminExecutable/temp/t_top_non_trie.csv # oc
    resultat=$?
    if [ "$resultat" -ne 0 ]; then
        echo "Erreur d'execution de la fonction CY_Truck_t1"
        exit 1
    fi 

    # Execution du code C qui tri en fonction des noms de villes dans l'ordre alphabétique    
    $CheminExecutable/progc/CY_Truck_t2 $CheminExecutable/temp/t_top_non_trie.csv > $CheminExecutable/data/t_top_10.csv
    resultat=$?
    if [ "$resultat" -ne 0 ]; then
        echo "Erreur d'execution de la fonction CY_Truck_t2"
        exit 1
    fi 

    # Récupere l'heure à la fin de l'exeempst.
    tmp_f=$(date +%s)

    # Calcule le temps d'exe en soustraillant les deux
    echo "Le temps d'execution est de" $((tmp_f - tmp_d)) "secondes"
    gnuplot $CheminExecutable/scriptgnu/t.gnu
fi

if [ $faire_s ]; then 
    echo "option s"

    cat <<EOF > $CheminExecutable/scriptgnu/s.gnu

#Paramètres du graphique
set terminal pngcairo size 1920,1080 enhanced font 'Times New Roman, 13'
set title "statistiques trajets"
set ylabel "y"
set xlabel "x"

#nom du fichier dans lequel le graphique apparaitra 
set output "$CheminExecutable/images/statistiques.png"

EOF

    gnuplot $CheminExecutable/scriptgnu/s.gnu

fi 


