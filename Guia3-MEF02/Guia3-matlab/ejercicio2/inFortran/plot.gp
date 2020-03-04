#set terminal postscript enhanced color
#set output "resultados.ps"

#unset border
#unset xtic
#unset ytic

plot "./resultados.dat" index 1 u 2:3 w l notitle,\
     '' index 1 u 2:3 w p pt 19 ps 3 lc rgb 'black' notitle,\
     '' index 0 u 2:3:1 with labels offset 1,-2 notitle,\
     '' index 0 u 2:3:($4*50):($5*50) w vectors title "Desplazamientos"
