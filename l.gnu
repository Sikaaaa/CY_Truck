#Paramètres du graphique
set terminal png
set title "Les 10 trajets les plus longs"
set xlabel "Id Route"
set ylabel "Distance en km"

#nom du fichier dans lequel le graphique apparaitra 
set output "./image/Les 10 trajets les plus longs.png" 

# Type de graphique
set style data histograms
set style fill solid
set boxwidth 0.4

# Pour que le graph soit dans le bon sens 
set yrange [0.5:*]
set xrange [0.5:*]

# Charger les données depuis le fichier
plot './data/l_trajet_plus_long.csv' using 1:xticlabels(2) title "T" with boxes