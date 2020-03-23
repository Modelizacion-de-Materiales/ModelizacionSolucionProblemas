ResumenGuia0: notes.pdf beamer.pdf OldResumen

notes.pdf: notes.aux Guia0
	pdflatex notes.tex

notes.aux: handout.pdf Guia0 notes.tex
	pdflatex notes.tex 

beamer.pdf: beamer.tex main.tex Guia0
	pdflatex beamer.tex

handout.pdf: handout.tex main.tex Guia0
	pdflatex handout.tex

OldResumen: Resumen/GUIA1-Resumen-2018.odp
	make -C Resumen/

Guia0: ./Guia0_python/ ./Guia0-Matlab/ ./Guia0-Fortran/Ejercicio1/
Guia0_python:
	make -C $@

clean:
	find -iname \*.aux   \
	  -o -iname \*.log\
	  -o -iname \*.nav\
	  -o -iname \*.out\
	  -o -iname \*.pdf\
	  -o -iname \*.snm\
	  -o -iname \*.toc\
	  -o -iname \*.aux\
	  | xargs rm


.PHONY: Guia0 Guia0_python
