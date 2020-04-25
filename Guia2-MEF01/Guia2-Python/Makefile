all: mefmods.py Ejercicio1 Ejercicio2 Ejercicio3

Ejercicio1: Ejercicio1/ mefmods.py
	make -C Ejercicio1

Ejercicio2: Ejercicio2/Ejercicio2.py mefmods.py
	make -C Ejercicio2/

Ejercicio3: Ejercicio3/ejercicio3.py mefmods.py
	make -C Ejercicio3

clean:
	find -iname \*.pyc\
	  -o -iname .\*.swp\
	  -o -iname __pycache__\
	  | xargs rm -r

.PHONY: Ejercicio1 Ejercicio2 Ejercicio3
