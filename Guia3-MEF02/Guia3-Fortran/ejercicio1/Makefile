all:  mefbase.o mainej1.o 
	gfortran mainej1.o mefbase.o -o x -llapack
	
prueba: mefbase.o mainej1b.o
	gfortran mainej1b.o mefbase.o -o xprueba -llapack
	
mainej1.o: mainej1.f90
	gfortran -c mainej1.f90
	
mefbase.o: mefbase.f90
	gfortran -c mefbase.f90
	
clean:
	rm *.o *.mod
	
mainej1b.o: mainej1b.f90
	gfortran -c mainej1b.f90