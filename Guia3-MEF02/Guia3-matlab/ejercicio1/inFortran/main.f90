!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Este programa resuelve una cadena de resortes.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

program main
implicit none

! Declaración de variables
!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! Matrices y variables
double precision, allocatable:: K(:,:), Kred(:,:), Kloca(:,:)  ! Matriz d rigidez
double precision, allocatable:: U(:), Uunks(:), Uvin(:)        ! Desplazamientos
double precision, allocatable:: X(:), Xvin(:), Xunks(:)        ! posiciones
double precision, allocatable:: F(:), Fvin(:), Funks(:)        ! Fuerzas

! Vectores de posiciones
integer, allocatable:: vvin(:), vunks(:)

!dimensiones
integer:: N, Nvin, Nunks                              ! nodos, vínculos e incognitas
integer:: g                                           ! grados de libertad por nodo

!indices y contadores
integer:: i,j,p,q

!Interpolación
double precision:: xint, uint                         ! Posicion y desplazamientos
double precision:: N1,N2                              ! Funciones de interpolación

! Otros parámetros
double precision, parameter:: delta=0.2d0, L=1.d0, locK=200.d0
                             ! Estas son 
                             ! el estiramiento del extremo
                             ! la longitud de cada elemento
                             ! La constante elástica de los resortes.
! Variables de subrutina
integer, allocatable:: ipiv(:)
integer::info=10

! Inicialización de variables
g=1                          ! Me interesa solo desplazamientos longitudinales
N=4                          ! cantidad de nodos
Nvin=2                       ! dos nodos vinculados
Nunks=g*N-Nvin                 ! El resto de los nodos se desplazan libremente

! Alocatación de variables
allocate( Kloca(2*g,2*g), K(g*N,g*N), Kred(Nunks,Nunks) )   ! Inicializo las matrices
allocate( U(g*N) , Uunks(Nunks) , Uvin(Nvin) )
allocate( X(N), Xvin(Nvin) , Xunks(Nunks) )
allocate( F(g*N) , Fvin(Nunks) , Funks(Nvin) )
allocate( vvin(Nvin) , vunks(Nunks) )
allocate(ipiv(Nunks))


! Requiero la matriz local
call matrizlocal(L,locK,g,Kloca)
! Matriz del sistema
call extendmat(g,N,Kloca,K)

print '(/,A)' , "Matriz del sistema"
do i=1,N
	print '(100F10.2)' , K(i,:)
end do


! primero, tengo que detectar la posicion de los vinculos
! En este caso es fácil porque son solo el amuramiento el estiramiento de la punta.
Xvin(1)=0.d0 ; Uvin(1)=0.d0
Xvin(2)=(N-1)*L ; Uvin(2)=delta
do i=1,N
	X(i)=(i-1)*L
end do



! Y ahora armo el vector de posiciones de vín
p=1
q=1

do i=1,N
	if (X(i)==Xvin(p)) then
		vvin(p)=i
		if (p<Nvin) p=p+1
	else
		vunks(q)=i
		if (q<Nunks) q=q+1
	end if
end do

print '(/,A)' , "Posiciones de las incognitas"
print*, vunks

print '(/,A)' , "Posiciones de los vínculos"
print*, vvin


! Sistema reducido
Kred=K(vunks,vunks)

print '(/,A)' , "Matriz reducida" 
do i =1,Nunks
	print '(100F10.3)' , Kred(i,:)
end do

Fvin=0.d0
Uunks=Fvin  - matmul(K(vunks,vvin),Uvin)
! resuelvo
call dgesv(Nunks, 1, Kred, Nunks, ipiv, Uunks, Nunks, info)
print*, "info =", info
! Reensamblo
print*, Uunks
U(vvin)=Uvin
U(vunks)=Uunks
deallocate(Kred)
allocate(Kred(Nvin,N))
Kred=K(vvin,:)

F(vvin)=matmul(Kred,U)
print '(/,A)' , "Fuerzas"
print*, F

print '(/,A)' , "Desplazamientos"
print*, U
end program
