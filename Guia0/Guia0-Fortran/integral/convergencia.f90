!-----------------------------------------------------------------------------------
!MARIANO FORTI - Programa principal para Problema 2, Guía 1.
!-----------------------------------------------------------------------------------

program convergencia
implicit none

integer::i,j,eof
real(8)::h,x,fx
integer::N,dN
real(8),parameter::a=0,b=30
real(8)::f,fa,fb
real(8)::IS,IT,ISn,ITn,AvS,AvT,AvSn,AvTn
real(8)::eS,eT



fa=f(a)
fb=f(b)



print*, "Aguarde un momento, se calculará el valor de la integral en función del tamaño de paso. "

open(1,file="IvsErr.dat")
write(1,*) "h	IS	eS	IT	eT	N"	!Ingreso en el archivo de salida

N=3							!los nombres de los datos a guardar.
h=abs(a-b)/N						!Inicio el espaciado entre valores de 

							!x para la primera iteración

!--------Tengo que hacer la lista del valor de la integral vs el tamaño de paso.

							!Inicio los valores de las integrales
IS=(b-a)*(fa+4*f((a+b)/2.)+fb)/6.			!Según el método de Simpson.
IT=((b-a)/2.-a)*(fa+f((b-a)/2))*.5+(b-(b-a)/2.)*(fb+f((b-a)/2.))*.5
							!Y según el método de los trapecios

do 
	x=a						!Inicio desde el comienzo del intervalo
	ISn=IS						!guardo los valores anteriores 
	ITn=IT						! de las integrales

	dN=int(N*(10.d0**0.1-1.d0))+1			!Con esto me genero una escala
	N=N+dN						!logarítmica en el paso de
	if( mod(N,2)/=0) N=N+1				!integración
	h=abs(a-b)/N					!

	open(2,file="f_x.dat")				!Abro un archivo donde voy a guardar
	write(2,*), x, f(x)				!los valores x; f(x). Guardo en el
							!primer registro a, f(a)
	do j=1,N					!
		x=x+h					!los x están espaciados por el paso
		fx=f(x)					!h, que va a ser el parámetro que me 
		write(2,*),x,fx				!interesa. Hasta acá guardo todos los 
	end do						!datos menos el primero y el último.
	
	close(2)					!cierro el archivo.

	call integrarSimpson(IS,"f_x.dat")		!Calculo la integral para el conjunto
	call integrarTrapecios(IT,"f_x.dat")		!datos actual, por ambos métodos.
	eS=abs((IS-ISn)/IS)				!y calculo el error respecto al paso
	eT=abs((IT-ITn)/IT)				!anterior.

	write(1,*),h,IS,eS,IT,eT,N			!Guardo toda esta info en un archivo
	if(eS<1e-8.and.eT<1e-8) exit			!Si el error sificientemente chico
							!salgo.
	

	
end do

!----------------------------------------Ahora me queda calcular el punto de aplicación
!----------------------------------------Pero también tendría que analizar la convergencia

print*, "Por favor sea paciente. Se analizará la convergencia de los promedios"

open(2,file="Avvserr.dat")
write(2,*), "h	AvS	eS	AvT	eT	N"

AvS=(b-a)*(a*fa+4*((a+b)/2.)*f((a+b)/2.)+fb*b)/6.			!Según el método de Simpson.
AvT=((b-a)/2.-a)*(a*fa+((b-a)/2)*f((b-a)/2))*.5+(b-(b-a)/2.)*(b*fb+((b-a)/2.)*f((b-a)/2.))*.5
AvS=AvS/IS
AvT=AvT/IT

N=3

do 
	x=a						!Inicio desde el comienzo del intervalo
	AvSn=AvS					!guardo los valores anteriores 
	AvTn=AvT					! de las integrales

	dN=int(N*(10.d0**0.1-1.d0))+1			!Con esto me genero una escala
	N=N+dN						!logarítmica en el paso de
	if( mod(N,2)/=0) N=N+1				!integración
	h=abs(a-b)/N					!

	open(3,file="xfx.dat")
	
	write(3,*), a,a*fa

	do j=1,N
		x=x+h					!
		write(3,*),x,x*f(x)				!guardo los valores de x y de
	end do
	close(3)

	call integrarSimpson(AvS,"xfx.dat")			!Luego solo me queda integrar estos
	call integrarTrapecios(AvT,"xfx.dat")			!datos, y esa integral la divido 
	AvS=AvS/IS						!por el valor anterior, para tener el 
	AvT=AvT/IT						!promedio que busco
	eS=abs((AvSn - AvS)/AvS)
	eT=abs((AvTn - AvT)/AvT)

	write(2,*), h, AvS, eS, AvT, eT, N
	if(eS<1e-8.and.eT<1e-8.and.N>100) exit
end do

!---------------------------------Imprimo en pantalla los resultados

print*, "Gracias por aguardar."
print*, " "
print*, "		Método de Simpson		Método de los trapecios"
print*, "------------------------------------------------------------------------"
write(*,*) "Fuerza (lbs)   |", IS, IT
print*, "Punto de       |"
write(*,*) "aplicación (ft)|", AvS, AvT
end program
