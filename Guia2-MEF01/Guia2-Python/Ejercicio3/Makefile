pane-results.pdf: ResultadoTensiones-02N.pdf ResultadoTensiones-03N.pdf ResultadoTensiones-04N.pdf\
	ResultadoTensiones-05N.pdf\
	ResultadoDesplazamientos-02N.pdf ResultadoDesplazamientos-03N.pdf ResultadoDesplazamientos-04N.pdf\
	ResultadoDesplazamientos-05N.pdf ./pane-results.tex
	pdflatex pane-results.tex

./ResultadoTensiones-02N.pdf: ejercicio3.py ../mefmods.py
	python3 -c "from ejercicio3 import barra; B = barra(2); B.plot_results()"

./ResultadoTensiones-03N.pdf: ejercicio3.py ../mefmods.py
	python3 -c "from ejercicio3 import barra; B = barra(3); B.plot_results()"
	
./ResultadoTensiones-04N.pdf: ejercicio3.py ../mefmods.py
	python3 -c "from ejercicio3 import barra; B = barra(4); B.plot_results()"

./ResultadoTensiones-05N.pdf: ejercicio3.py ../mefmods.py
	python3 -c "from ejercicio3 import barra; B = barra(5); B.plot_results()"

./ResultadoDesplazamientos-02N.pdf: ejercicio3.py ../mefmods.py
	python3 -c "from ejercicio3 import barra; B = barra(2); B.plot_results()"

./ResultadoDesplazamientos-03N.pdf: ejercicio3.py ../mefmods.py
	python3 -c "from ejercicio3 import barra; B = barra(3); B.plot_results()"
	
./ResultadoDesplazamientos-04N.pdf: ejercicio3.py ../mefmods.py
	python3 -c "from ejercicio3 import barra; B = barra(4); B.plot_results()"

./ResultadoDesplazamientos-05N.pdf: ejercicio3.py ../mefmods.py
	python3 -c "from ejercicio3 import barra; B = barra(5); B.plot_results()"

clean: 
	find -iname __pycache__\
	  -o -iname \*.pyc\
	  | xargs rm -r
