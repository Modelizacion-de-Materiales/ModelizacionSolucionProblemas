INCLUDES := ./01-Problema-1.tex ./02-Problema2.tex ./03-Problema3.tex 
CODES := ./codesolve.m ./codesolve.txt 

all: notes.pdf beamer.pdf


notes.pdf: handout.aux notes.aux
	pdflatex notes.tex

notes.aux: notes.tex $(INCLUDES) $(CODES)
	pdflatex notes.tex

handout.pdf: handout.aux

handout.aux: handout.tex main.tex $(INCLUDES) $(CODES)
	pdflatex handout.tex

beamer.pdf: beamer.tex $(INCLUDES) $(CODES)
	pdflatex beamer.tex

Ejercicio1: ./Guia2-Python/Ejercicio1/
	make -C ./Guia2-Python/Ejercicio1

Ejercicio2: ./Guia2-Python/Ejercicio2
	make -C ./Guia2-Python/Ejercicio2/

Ejercicio3: ./Guia2-Python/Ejercicio3
	make -C ./Guia2-Python/Ejercicio3

.PHONY: Ejercicio1 Ejercicio2 Ejercicio3

clean: 
	find -iname \*.aux\
	  -o -iname \*.log\
	  -o -iname \*.nav\
	  -o -iname \*.out\
	  -o -iname \*.snm\
	  -o -iname \*.toc\
	  -o -iname \*.aux\
	  -o -iname \*.log\
	  -o -iname \*.nav\
	  -o -iname \*.out\
	  -o -iname \*.snm\
	  -o -iname \*.toc\
	  |xargs rm
