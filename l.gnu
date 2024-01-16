#Paramètres du graphique
set terminal pngcairo size 1920,1080 enhanced font 'Times New Roman, 13'
set title "Les 10 trajets les plus longs"
set ylabel "Distance en km"
set xlabel "Id Route"

#nom du fichier dans lequel le graphique apparaitra 
set output "./image/Les 10 trajets les plus longs.png" 

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
plot './data/l_trajet_plus_long.csv' using (2*$0+1):2:xticlabels(1) title "Distance" with boxes