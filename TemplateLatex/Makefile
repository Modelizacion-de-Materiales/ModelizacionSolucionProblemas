# INCLUDES=./FRAMES/title.tex ./FRAMES/01-WHOIAM.tex 
INCLUDES=./??-SECCION/*.tex ./10-CONCLUS/*.tex ./PREAMBLE/*.tex

clase: main.tex ${INCLUDES}
	# hay que compilar dos veces para que 
	# se hagan bien tanto las referencias cruzadas como 
	# la tabla de contenidos. 
	pdflatex main.tex
	pdflatex main.tex

clean:
	find -iname \*.out \
	  -o -iname \*.log \
	  -o -iname \*.aux \
	  -o -iname \*.snm \
	  -o -iname .\*.swp \
	  -o -iname \*.toc \
	  -o -iname \*.asp \
	  -o -iname ~\* \
	  -o -iname \*.nav \
	  |xargs rm
#	rm *.out *.log *.aux ./??-SECCION/*.{log,out,aux} 10-CONCLUS/*.{log,out,aux}
