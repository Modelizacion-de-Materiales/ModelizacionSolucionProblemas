MATLAB = matlab -nodesktop -nosplash -noFigureWindows -r 
ising: ising.m INPUT.m
	${MATLAB} 'INPUT ; exit'  

report: allplots #plot2x2
	pdflatex report.tex
#report: plot_escal #plot_cv
#	pdflatex report.tex

allplots: plot plot2x2 

plot: plot.gpi
	gnuplot plot.gpi

plot2x2: plot2x2.gpi
	gnuplot plot2x2.gpi

#lot_escal: plot_scale.gpi
#       gnuplot plot_scale.gpi 

clean: 
	find -iname \*.log \
	  -o -iname \*.aux \
	  -o -iname \*.out \
	  -o -iname \*.swp\
	  -o -iname \*.snm\
	  -o -iname \*.toc\
	  -o -iname \*.nav\
	   | xargs rm 


cleanpdfs:
	find -iname \*.pdf\
	  -o -iname \*.eps\
	| xargs rm

cleantex: 
	find -iname scale\*.tex | xargs rm
