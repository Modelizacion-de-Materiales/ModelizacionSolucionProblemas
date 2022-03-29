SOURCES := *.m

all: errores.pdf soluciones1.pdf $(SOURCES)

soluciones1.pdf: tabla-a-mano.txt $(SOURCES)

tabla-a-mano.txt: $(SOURCES)
	octave res_a_mano.m --no-gui -W > tabla-a-mano.txt

errores.pdf: $(SOURCES)
	octave paso_optimo.m --no-gui -W
