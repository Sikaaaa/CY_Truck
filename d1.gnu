# Paramètres du graphique
set terminal png
set title "Le plus de trajets"
set xlabel "Conducteurs"
set ylabel "Nombre de Trajets"

# Nom du fichier dans lequel le graphique apparaîtra
set output "./image/Le_plus_de_trajet.png"

# Type de graphique
set style data histograms
set style fill solid
set boxwidth 0.4

# Pour que le graph soit dans le bon sens 
set yrange [0.5:*]
set xrange [0.5:*]

# Charger les données depuis le fichier
plot './data/d1_top_10.csv' using 1:xticlabels(2) title "Nombre de trajets" with boxes







