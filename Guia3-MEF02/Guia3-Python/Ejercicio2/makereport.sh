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
echo "\begin{document}" >> $report

for file in chapa*.ps 
    do
        epstopdf $file -o ${file/ps/pdf}
        echo "\begin{frame}" >> $report
        echo "\frametitle{${file}}" >> $report
        echo "\includegraphics[width=\textwidth]{${file/ps/pdf}}" >> $report
        echo "\end{frame}" >> $report
    done
echo "\end{document}">>  $report
