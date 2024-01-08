#Paramètres du graphique
set terminal png
set title "Les 10 trajets les plus longs"
set xlabel "Distance en km"
set ylabel "Id Route"

#nom du fichier dans lequel le graphique apparaitra 
set output "./image/Les 10 trajets les plus longs.png" 

# Type de graphique
set style fill solid
set boxwidth 0.7
set size 1,1 #définir la taille de l'image par rapport au graphique
set key font "Times New Roman, 13"
set border lc rgb 'purple'

# Charger les données depuis le fichier
plot './data/l_trajet_plus_long.csv' using 1:xticlabels(2) title "Distance" with boxes #générer le graphique en utilisant le fichier l_trajet_le_plus_long.csv