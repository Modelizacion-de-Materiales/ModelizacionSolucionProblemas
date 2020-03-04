sources=main.f90 subroutines.f90
fc=gfortran
ops=-o
executable= x
libs= -llapack
x:
	$(fc) $(libs) $(ops) $(executable) $(sources)

clean:
	rm $(executable) ; touch $(sources)

touch:
	touch $(sources)
