escaleo: escaleo.py ejercicio1.py MakeA.py
	python3 escaleo.py

Graficos:  ./Temperaturas-Flujos-1.pdf ./Temperaturas-Flujos-2.pdf

./Temperaturas-Flujos-1.pdf: Temps-temperatura.dat
	pdftk Temperaturas-temperatura.pdf Temperaturas-temperatura-Flujos.pdf cat output Temperaturas-Flujos-1.pdf
	rm Temperaturas-temperatura.pdf Temperaturas-temperatura-Flujos.pdf

Temps-temperatura.dat: ejercicio1.py geo.py MakeA.py
	sed -i "s/abajo = .*/abajo = \'temperatura\'/" tycc.py
	python3 ./ejercicio1.py

Temperaturas-Flujos-2.pdf: ./Temps-flujo.dat
	pdftk Temperaturas-flujo.pdf Temperaturas-flujo-Flujos.pdf cat output Temperaturas-Flujos-2.pdf
	rm Temperaturas-flujo.pdf Temperaturas-flujo-Flujos.pdf

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

