# INCLUDES=./FRAMES/title.tex ./FRAMES/01-WHOIAM.tex 
INCLUDES=*/*.tex 

beamer.pdf: ${INCLUDES} main.tex beam.tex DRAWINGS
	pdflatex beam.tex
	pdflatex beam.tex

handout.pdf:  handout.tex ${INCLUDES} main.tex
	pdflatex handout.tex
	pdflatex handout.tex
	
notes.pdf: handout.pdf ${INCLUDES} main.tex notes.tex
	pdflatex notes.tex
	pdflatex notes.tex

.PHONY: DRAWINGS 
DRAWINGS: DRAWINGS/
	make -C $@

#DRAWINGS/RED2d.pdf: DRAWINGS/RED2d.tex
#	cd DRAWINGS; pdflatex RED2d.tex ; cd ..

clean: 
	find -iname \*.log \
	-o -iname \*.out \
	  -o -iname \*.aux \
	  -o -iname \*.toc \
	  -o -iname \*.vrb \
	  -o -iname \*.snm \
	  -o -iname \*.nav \
	  | xargs rm
