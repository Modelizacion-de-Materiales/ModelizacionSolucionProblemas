! Subrutina de dimensionamiento del problema. Mariano Forti
!-----------------------------------------------------------

subroutine getdims(archivo, N,nx, nvin)
implicit none

!variables de i/o
integer::N,nx,nvin
 character(8)::archivo

!variables locales
real(8)::xo,xi
integer::cvin,fuerza,coordenada,nodo
integer::eof

N=1
nx=0
nvin=0
xo=0.
xi=0.
nodo=0
coordenada=1
fuerza=2
eof=0
eof=0
print*, "leyendo dimensiones de "
print*, archivo
open(1,file=archivo)
do
	read(1,*,iostat=eof), xi,cvin
	if(eof/=0) exit
	if(xi/=xo) then
		xo=xi
		N=N+1
	end if
	if(cvin==fuerza) nx=nx+1
	if(cvin==nodo) nx=nx+2
	if(cvin==coordenada) nvin=nvin+1
end do
 close(1)
end subroutine


