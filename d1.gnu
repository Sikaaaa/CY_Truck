# Paramètres du graphique
set terminal png
set xlabel "Conducteurs"
set y2label "Nombre de Trajets"
set ylabel "Les dix meilleurs chauffeurs"

# Nom du fichier dans lequel le graphique apparaîtra
set output "./image/Le_plus_de_trajet.png"

# Type de graphique
set style data histograms
set style fill solid

# Pour que le graph soit dans le bon sens
set xtics rotate
set ytics rotate
set y2tics rotate
unset ytics; set y2tics mirror
set terminal pngcairo size 1080,1920

# Charger les données depuis le fichier
set datafile separator ','
plot './data/d1_top_10.csv' using 1:xticlabels(2) axes x1y2 notitle