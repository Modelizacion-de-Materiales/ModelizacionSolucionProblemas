sources=barra.f90 funcs.f90 getdims.f90 getVecs.f90 matR.f90
FC=gfortran
libraries= -llapack -lblas
CFLAGS= -o
output= x

$(output): $(sources)
	$(FC) $(sources) $(libraries) $(CFLAGS) $(output)


