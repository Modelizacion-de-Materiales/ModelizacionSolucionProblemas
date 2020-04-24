#Ejercicios := $(wildcard Ejercicio*/)
Ejercicios := $(wildcard Ejercicio3/)

all: $(Ejercicios)
$(Ejercicios):
	 make -C $@
#

.PHONY: all $(Ejercicios)


clean:
	find -iname \*.log \
	  -o -iname \*.aux \
	  -o -iname \*.toc \
	  -o -iname \*.nav \
	  -o -iname \*.snv \
	  -o -iname \*.out \
	  | xargs rm
