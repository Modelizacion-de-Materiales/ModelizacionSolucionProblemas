ResumenGuia0: notes.pdf beamer.pdf

notes.pdf: notes.aux Guia0
	pdflatex notes.tex

notes.aux: handout.pdf Guia0 notes.tex
	pdflatex notes.tex 

beamer.pdf: beamer.tex main.tex Guia0
	pdflatex beamer.tex

handout.pdf: handout.tex main.tex Guia0
	pdflatex handout.tex


Guia0: ./Guia0_python
Guia0_python:
	make -C Guia0_python

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
