program mainej1
use mefbase
implicit none

integer :: N
! estas variables guardan, en orden:
! número de gl incógnita, número de gl vinculados,
! número de gl por nodo, número de elementos
! número de nodos por elemento, y número de nodos.
integer :: nr , ns , gl , ne , nnxe , nn

double precision, allocatable :: M(:,:), Kloc(:,:)
double precision, allocatable :: MN(:,:)
integer, allocatable :: MC(:,:) , r(:), s(:)
double precision, allocatable :: U(:) , F(:) 
double precision :: k
integer :: e,i,j


! caso trivial del ejercicio 1
gl = 1 
nnxe = 2
nn = 4
ne = nn-1
k = 200.d0
!!! matriz de conectividad.
allocate(MC(ne,nnxe))
do e=1,ne
   MC(e,:)=(/e,e+1/)
enddo
   

!!! matriz de rigidez local   


do i=1,nnxe*gl
  print*, Kloc(i,:)/k
enddo


!!! matriz de rigidez global
!!! ensamble a mano
allocate(M(nn*gl,nn*gl))
M = 0.d0
allocate(Kloc(nnxe*gl,nnxe*gl))
Kloc = k*reshape( (/1,-1,-1,1/) , (/2 ,2 /) )
do e=1,ne
   call ensamble(gl,nnxe,nn,MC(e,:),M,Kloc)
enddo

print*, 'matriz global'
print*, '-------------------'
do i=1,nn*gl
  print*, M(i,:)/k
enddo

!!! preparo para la solución
allocate(U(nn*gl))
U = 0.d0
allocate(F(nn*gl))
F = 0.d0
nr = 2 
ns = 2
allocate(r(nr),s(ns) ) 
r=(/2,3/)
s=(/1,4/)
U(s)=(/ 0.d0,0.02d0 /)
F(r)=0.d0

call mdfsolver(nn*gl,M,U,F,r,s,nr)
print*, ' desplazamientos '
print*, '-------------------'
print*, U 
print*, ' Fuerzas '
print*, '-------------------'
print*, F

! condiciones de contorno rudimentariamente ( a mano )

end program mainej1
