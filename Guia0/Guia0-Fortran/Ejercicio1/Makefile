all: E1G1.exe listasalida.dat

listasalida.dat: E1G1.exe ./ListaXY.dat 
	./E1G1.exe; gnuplot plotall.gpi

E1G1.exe:  datahandle.f90 basefunctions.f90 main.f90
	gfortran  datahandle.f90 basefunctions.f90 main.f90 -o E1G1.exe -llapack 



