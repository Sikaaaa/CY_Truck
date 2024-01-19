# Paramètres du graphique
set terminal png
set xlabel "Conducteurs"
set y2label "Nombre de km"
set ylabel "Les conducteurs avec le plus de km au compteur"

# Nom du fichier dans lequel le graphique apparaîtra
set output "./image/Les_conducteurs_avec_le_plus_de_km.png"


# Type de graphique
set style data histograms
set style fill solid
set boxwidth 1.5
# set y2range [0:16000]

# Pour que le graph soit dans le bon sens
set xtics rotate
set ytics rotate
set y2tics rotate
unset ytics; set y2tics mirror
set terminal pngcairo size 1080,1920 enhanced font 'Times New Roman, 13'


# Charger les données depuis le fichier
set datafile separator ','
plot './demo/d2_top_10.csv' using 1:xticlabels(2) axes x1y2 notitle

