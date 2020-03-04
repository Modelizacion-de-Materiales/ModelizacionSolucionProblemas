program mainej1
use mefbase
implicit none

integer :: N
! estas variables guardan, en orden:
! n�mero de gl inc�gnita, n�mero de gl vinculados,
! n�mero de gl por nodo, n�mero de elementos
! n�mero de nodos por elemento, y n�mero de nodos.
integer :: nr , ns , gl , ne , nnxe , nn
integer :: i

double precision, allocatable :: M(:,:), Kloc(:,:)
double precision, allocatable :: MN(:,:)
integer, allocatable :: MC(:,:) , r(:), s(:)
integer, allocatable :: MVIN(:,:)
!double precision, allocatable :: U(:) , F(:) 
!double precision :: k
!integer :: e,i,j
double precision, allocatable :: XVIN(:,:)
double precision, allocatable :: UVIN(:), MP(:)

! caso trivial del ejercicio 1
! trato de leer del archivo.
! condiciones de contorno rudimentariamente ( a mano )

call leermimsh(gl,nn,nnxe,ne,MN,MC)

print*, 'leido grados de libertad por ndo', gl
print*, 'leido numero de nodos', nn
print*, 'leido numero de elementos', ne
print*, 'leido numero de nodos por elemento', nnxe
print*, 'leida matriz de conectividad'
do i=1,ne
  print*,MC(i,:)
enddo
print*, 'leida matriz de nodos'
do i=1,nn
  print*,MN(i,:)
enddo

call leervinc(gl,nn,nnxe,MN,MP,MVIN)

end program mainej1
