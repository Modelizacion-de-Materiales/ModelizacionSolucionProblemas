!barra.f90 Programa de elementos finitos en 1D - Mariano Forti
!-----------------------------------------------------------

program main
implicit none

!-----------------------------------------------------------
!Declaración de variables.
!-----------------------------------------------------------
integer::N		!Es la cantidad de elementos 
real(8),parameter::E=210.e9, In=2.e-4, L=6., kresorte=200.e3, P=-50.e3
			!Pa, m^4, m, kN/m y kN resp.
real(8)::dL		!Tamaño del elemento.
integer::g		!Grados de libertad.
integer::nx		!Es la cantidad de incognitas.
integer::nvin		!Numero de vinculos.
integer,allocatable::i(:),j(:)
			!Son los vectores que guardan las
			!posiciones de las incógnitas
			!y los vínculos, respectivamente.
integer::v,w,s		!Son los índices que voy a usar.

real(8)::R(4,4)		!Esta es la matriz idividual 
			!para cada nodo.
real(8),allocatable::K(:,:),A(:,:)
			!Estas son la matriz de rigidez y
			!la que me ayuda a resolver el sis
			!tema de ecuaciones.
real(8),allocatable::D(:),Q(:)
			!Estos son los vectores que llevaran
			!todos los desplazamientos y las fuerzas,
			!respectivamente.
real(8),allocatable::DX(:),QX(:),Dvin(:),Qvin(:)
			!Estos son los vectores que guardan las 
			!incógnitas (X) y los vínculos (vin),
			!y un vector auxiliar que me va a servir
			!para resolver el sistema.
real(8),allocatable::X(:)
			!Este vector da las posiciones de 
			!los nodos.
real(8)::xint,u		!Son las variables para interpolar
			!los desplazamientos.
real(8)::N1,N2,N3,N4
integer::info
integer,allocatable::ipiv(:)
!-----------------------------------------------------------
!----------------------Inicialización de variables.
!-----------------------------------------------------------

g=2
info=2
 call getdims("vinculos",N,nx,nvin)
print*, "dimensiones"
print*, N, nx,nvin

!------con estas variables puedo iniciar las matrices y vectores.

allocate(D(g*(N)))
allocate(Q(g*(N)))
allocate(K(g*(N),g*(N)))
allocate(A(nx,nx))
allocate(i(nx))
allocate(DX(nx))
allocate(QX(nvin))
allocate(j(nvin))
allocate(Dvin(nvin))
allocate(Qvin(nx))
allocate(X(N))
allocate(ipiv(nx))

D=0.
Q=0.
K=0.
A=0.
i=0.
DX=0.
QX=0.
j=0.
Dvin=0.
Qvin=0.
X=0.
ipiv=0.

!---------Ahora inicio las posiciones de los nodos.

!-----------------------------------------------------------
!----------------Armado de vectores.
!-----------------------------------------------------------
 call getVecs("vinculos",N,nx,nvin,i,j,X,Dvin,Qvin)


print*,"Vectores del sistema"
print*,"X"
print*, X
print*,"i"
print*, i
print*,"j"
print*, j
print*,"Dvin"
print*, Dvin
print*,"Qvin"
print*, Qvin

!-----------------------------------------------------------
!-----------------Armado de la matriz.
! ----------------------------------------------------------
print*, "----"
do v=1,N-1
	dL=X(v+1)-X(v)
	print*,dL
	call matR(R,dL)
	R=(E*In/dL**3)*R
	do w=1,2*g
		do s=1,2*g
			K(g*(v-1)+w,g*(v-1)+s)=K(g*(v-1)+w,g*(v-1)+s)+R(w,s)
		end do
	end do
end do
K(g*N-1,g*N-1)=K(g*N-1,g*N-1)+kresorte
print*,"Matriz del sistema"
do v=1,2*(N)
	write(*,'(25F15.3)'), K(v,:)
end do

!-----------------------------------------------------------
!-----------------Resolución del sistema.
! ----------------------------------------------------------



if(nvin/=0) then					!Salvo que no tenga desplazamientos
	print*, "vector de resultados"
	do v=1,nx				!para resolver,
		do w=1,nx
			A(v,w)=K(i(v),i(w))	!armo la matriz para
		end do				!resolver los desoplazamientos
						!incognita.
		DX(v)=Qvin(v)			!Con esto armo el vector de resultados.
		do w=1,nvin			!
			DX(v)=DX(v)-K(i(v),j(w))*Dvin(w)
			
		end do				!
		print*, DX
	end do	
print*,"-----------"

	call dgesv(nx,1,A,nx,IPIV,DX,nx,info)	!Resuelvo el sistema que me da los 

						!desplazamientos.
	D(i)=DX					!pongo en el vector los desplazamientos
						!encontrados.
	print*, "Resolución de incógnitas"	
	print*, DX			!

	Q(i)=Qvin				!Y en el vector de fuerzas cargo las 
end if						!fuerzas vínculo.


print*,"-----------"
deallocate(A)
allocate(A(nvin,g*(N)))				!Rearmo la matriz para 
if(nvin/=0) then					!Salvo que no tenga fuerzas incognita,
	D(j)=Dvin				!Termino de armar el vector de desplazamientos
						!con los vínculos, para poder usarlo en
						!en la cuenta.
	do v=1,nvin
		do w=1,g*(N)
			A(v,w)=K(j(v),w)	!armo la matriz que
		end do				!voy a usar para calcular las reacciones.
	end do
	QX=matmul(A,D)				!Calculo las reacciones.
	Q(j)=QX					!Termino de armar el vector de fuerzas.
end if
!-----------------------------------------------------------
!------------Recuperación de los datos y cálculo de los desplazamientos
!-----------------------------------------------------------
open(1,file="resultados")
write(1,*),"#	posición (m)	desplazamiento (m)	ángulo	Fuerza (kN)	Momento (kNm)"
do v=1,N
	write(1,*),X(v),D(g*v-1),D(g*v),Q(g*v-1),Q(g*v)
end do
 close(1)
open(2,file="desplazamientos")
write(2,*),"# x(m)	u(m)"
do v=1,N-1
	dL=X(v+1)-X(v)
	xint=X(v)
	u=N1(xint-X(v),dL)*D(g*v-1)+N2(xint-X(v),dL)*D(g*v)+N3(xint-X(v),dL)*D(g*v+1)+N4(xint-X(v),dL)*D(g*v+2)
	write(2,*), xint, u
	do w=1,10
		xint=xint+dL/10.
		u=N1(xint-X(v),dL)*D(g*v-1)+N2(xint-X(v),dL)*D(g*v)+N3(xint-X(v),dL)*D(g*v+1)+N4(xint-X(v),dL)*D(g*v+2)
		write(2,*), xint, u
	end do
end do


end program


