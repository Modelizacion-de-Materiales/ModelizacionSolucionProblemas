all: ejercicio2-g1.exe


integrales.o:  integrales.f90
	gfortran -c integrales.f90 

readparam.o : readparam.f90
	gfortran -c readparam.f90

ejercicio2-g1.o: ejercicio2-g1.f90  integrales.o readparam.o 
	gfortran -c integrales.o readparam.o ejercicio2-g1.f90

ejercicio2-g1.exe: ejercicio2-g1.o  integrales.o readparam.o
	gfortran readparam.o integrales.o ejercicio2-g1.o -o ejercicio2-g1.exe

clean: 
	rm *.o
