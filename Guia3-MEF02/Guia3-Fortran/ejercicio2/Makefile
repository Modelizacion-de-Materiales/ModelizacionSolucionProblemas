all: mefbase.o ejercicio.o
	gfortran mefbase.o ejercicio.o -o ejercicio -llapack

mefbase.o: mefbase.f90
	gfortran -C mefbase.f90 

ejercicio.o: ejercicio.f90 
	gfortran -C ejercicio.f90


clean:
	rm *.mod *.o ejercicio


	
