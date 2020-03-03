x: timevolv.o getdata.o mainej2.o
	gfortran  timevolv.o getdata.o  mainej2.o  -llapack -o x

getdata.o: getdata.f90
	gfortran -c getdata.f90

timevolv.o:  timevolv.f90
	gfortran -c timevolv.f90

mainej2.o: mainej2.f90
	gfortran -c mainej2.f90
