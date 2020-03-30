# revisar ! anda pero tengo quearreglar el makefile para que respete orden
#escaleo.pdf: plotsNxN.pdf
#	python3 -c "from ejercicio1 import fitescaleo; fitescaleo('tabla-tiempos.dat')"
#	
#plotsNxN.pdf: fitescaleo.pdf
#	pdftk fitescaleo.pdf PlotsNxN.pdf cat output escaleo.pdf
#
#tabla-tiempos.dat: ejercicio1.py MakeA.py 
#	python3 -c 'from ejercicio1 import escaleo; escaleo()' # tambien sale fitescaleo.pdf
#

Graficos:  ./Temperaturas-Flujos-1.pdf ./Temperaturas-Flujos-2.pdf

./Temperaturas-Flujos-1.pdf: Temps-temperatura.dat
	pdftk Temps-temperatura.pdf Temps-temperatura-Flujos.pdf cat output Temperaturas-Flujos-1.pdf
	rm Temps-temperatura.pdf Temps-temperatura-Flujos.pdf

Temps-temperatura.dat: ejercicio1.py geo.py MakeA.py
	sed -i "s/abajo = .*/abajo = \'temperatura\'/" tycc.py
	python3 ./ejercicio1.py

Temperaturas-Flujos-2.pdf: ./Temps-flujo.dat
	pdftk Temps-flujo.pdf Temps-flujo-Flujos.pdf cat output Temperaturas-Flujos-2.pdf
	rm Temps-flujo.pdf Temps-flujo-Flujos.pdf

Temps-flujo.dat: ejercicio1.py geo.py MakeA.py
	sed -i "s/abajo = .*/abajo = \'flujo\'/" tycc.py
	python3 ./ejercicio1.py


clean:
	find -iname \*.pyc\
	  -o -iname .*.swp\
	  |xargs rm 

clean-results: 
	find -iname \*.pdf\
	  -o -iname \*.dat\
	  | xargs rm

.PHONY: escaleo.pdf
