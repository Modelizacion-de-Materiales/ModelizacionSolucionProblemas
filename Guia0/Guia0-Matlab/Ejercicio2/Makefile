Ejercicio: plot-errores.pdf

plot-errores.pdf: plot-errores.tex  Errores.tex
	pdflatex plot-errores.tex

Errores.tex: *.m
	octave  --no-gui paso_optimo.m 


clean:
	find -iname \*.aux\
	  -o -iname \*.out\
	  -o -iname \*.log\
	  -o -iname \*.toc\
	  -not -name plot-errores.pdf\
	  -not -name \*-inc.pdf
#	  | xargs rm

.PHONY: plot-errores.pdf
