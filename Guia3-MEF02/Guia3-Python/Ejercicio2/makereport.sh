#!/bin/bash
#===============================================================================
#
#          FILE:  makereport.sh
# 
#         USAGE:  ./makereport.sh 
# 
#   DESCRIPTION:  G
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Mariano Forti (MF), mfotri@cnea.gov.ar
#       COMPANY:  Comisión Nacional de Energía Atómica
#       VERSION:  1.0
#       CREATED:  07/07/20 15:21:28 -03
#      REVISION:  ---
#===============================================================================
report=report.tex
echo "\documentclass{beamer}" > $report
echo "\usepackage{tikz}" >> $report
echo "\usepackage{amsmath}" >> $report
echo "\begin{document}" >> $report

for file in chapa*.jpg
    do
        fe=$(echo  $file  | tr -d -c 0-9.)
        newfile=${file/0\./0}
        if [ $newfile != $file ]
        then
            mv $file $newfile
        fi
        echo "\begin{frame}" >> $report
        echo "\frametitle{${file/\.jpg/}}" >> $report
        echo "\includegraphics[width=\textwidth]{$newfile}" >> $report
        echo "\begin{tikzpicture}[overlay] " >> $report
        echo "    \node at (-7.8,1.6) {\tiny $\sigma_{max} (Pa) $}; " >> $report
        echo "    \node at (-7.7,0.8) {\tiny $ F_{x} (N) $}; " >> $report
        echo "    \node at (-3.0,0.8) {\tiny $ F_{y} (N) $}; " >> $report
        echo "\end{tikzpicture} " >> $report
        echo "\end{frame}" >> $report
    done
echo "\end{document}">>  $report
