#récupérer le chemin absolue du fichier 
CheminExecutable=system("realpath .")

print "Le chemin absolu du répertoire en cours est :", CheminExecutable

# Paramètres du graphique
set terminal png
set xlabel "Conducteurs"
set y2label "Nombre de Trajets"
set ylabel "Les dix meilleurs chauffeurs"

# Nom du fichier dans lequel le graphique apparaîtra
set output CheminExecutable ."/images/Le_plus_de_trajet.png"

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
plot CheminExecutable .'/data/d1_top_10.csv' using 1:xticlabels(2) axes x1y2 notitle