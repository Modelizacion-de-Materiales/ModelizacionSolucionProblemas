pane-Puente.pdf: Puente.pdf PuenteInicial.pdf
	pdftk PuenteInicial.pdf Puente.pdf  cat output pane-Puente.pdf

Puente.pdf: Puente.ge Ejercicio2.py ../mefmods.py
	./Ejercicio2.py 

PuenteInicial.pdf: Puente.ge Ejercicio2.py ../mefmods.py
	./Ejercicio2.py

restart: 
	rm *.pdf


