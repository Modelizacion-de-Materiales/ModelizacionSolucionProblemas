#!/bin/bash
#===============================================================================
#
#          FILE:  ej2-g2.sh
# 
#         USAGE:  ./ej2-g2.sh 
# 
#   DESCRIPTION:  Resolucion del ejercicio 2 barriendo todas las posibilidades.
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Mariano Forti (MF), marianodforti@gmail.com
#       COMPANY:  Comisión Nacional de Energía Atómica
#       VERSION:  1.0
#       CREATED:  24/04/15 14:19:58 ART
#      REVISION:  ---
#===============================================================================

EXE=./x

declare -a DT
DT=("0.5" "0.65" "0.7" )
METH=("1" "2" "3")
for dt in ${DT[@]}
do
  for m in ${METH[@]}
  do 
  echo $dt $m
  echo "======================="
  sed -i "s/.*METHOD.*/METHOD = $m/g" DATIN
  sed -i "s/.*DT.*/DT = $dt/g" DATIN
  cp DATIN "DATIN_"$m"_"$dt
   $EXE &> output.txt
   /usr/bin/gnuplot plottmp.gpi
   /usr/bin/gnuplot tmprofile.gpi 
done
done
