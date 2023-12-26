# Paramètres du graphique
set terminal png
set title "Les conducteurs avec le plus de km au compteur"
set xlabel "Conducteurs"
set ylabel "Nombre de km"

# Nom du fichier dans lequel le graphique apparaîtra
set output "./image/Les_conducteurs_avec_le_plus_de_km.png"

# Type de graphique
set style data histograms
set style fill solid
set boxwidth 0.5

# Pour que le graph soit dans le bon sens 
set yrange [0.5:*]
set xrange [0:*]

# Charger les données depuis le fichier
plot './data/d2_top_10.csv' using 1:xticlabels(2) title "Nombre de trajets" with boxes






