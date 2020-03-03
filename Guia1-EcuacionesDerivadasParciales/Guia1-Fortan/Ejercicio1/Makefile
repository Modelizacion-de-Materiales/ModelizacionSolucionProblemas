all: x 

x: subsej2.o mainej2.o
	gfortran  subsej2.o mainej2.o   -o x -llapack

subsej2.o: subsej2.f90
	gfortran -c subsej2.f90 

mainej2.o: mainej2.f90
	gfortran -c mainej2.f90

