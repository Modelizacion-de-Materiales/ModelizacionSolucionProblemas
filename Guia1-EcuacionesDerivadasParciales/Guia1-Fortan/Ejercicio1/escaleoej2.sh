#!/bin/bash
#===============================================================================
#
#          FILE:  escaleoej2.sh
# 
#         USAGE:  ./escaleoej2.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Mariano Forti (MF), marianodforti@gmail.com
#       COMPANY:  Comisión Nacional de Energía Atómica
#       VERSION:  1.0
#       CREATED:  04/16/2014 07:49:18 PM ART
#      REVISION:  ---
#===============================================================================

rm tiempos.dat

N=3
echo $N
while [ $N -le 100 ]
do
  echo entro al while
  sed -i "s/.*NX.*/NX = $N/" DATIN
  sed -i "s/.*NY.*/NY = $N/" DATIN
  dN=$( echo " $N * ( e( 0.1 * l(10) ) -1 ) " | bc -l )
  N=$(echo "$N+$dN" | bc -l | awk '{ print int($1+1) }' )
  ./x
done

