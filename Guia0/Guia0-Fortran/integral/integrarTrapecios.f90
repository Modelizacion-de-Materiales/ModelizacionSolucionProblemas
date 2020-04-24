!--------------------------------------------------------------------------------
! MARIANO FORTI - Subrutina para integración por método de los Trapecios
!--------------------------------------------------------------------------------

subroutine integrarTrapecios(IT,funcion)	!La subrutina toma los datos 
implicit none					!X, Y  guardados en el archivo
						!funcion y calcula la integral IS.
						!Para integrar por este método
						!necesito guardar:
real(8)::x,xn,fx,fn,IT				!x actual y xn anterior,
						!fx y fn anterior
						!IT es el valor de la integral
character(len=7)::funcion			!Tengo que definir el nombre
						!del archivo donde estan los
						!datos de entrada.

integer::eof					!Y necesito un indicador
						!de si llegué al final del
						!archivo.

open(5,file=funcion)				
read(5,*),xn,fn					!Leo el primer dato
IT=0						!E inicializo la salida.

do 						!Ahora recorro el archivo
	read(5,*,iostat=eof),x,fx		!leyendo x, f(x)
	IT=IT+.5*(x-xn)*(fx+fn)			!y actualizando el valor de
	xn=x					!la integral. Luego guardo
	fn=fx					!los datos anteriores y
	if(eof/=0) exit				!abanzo, salvo que esté al final.
end do
close(5)					!cuando llego al final, ya tengo la integral.

end subroutine
