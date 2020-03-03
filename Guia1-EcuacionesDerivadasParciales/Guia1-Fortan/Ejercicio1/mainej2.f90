program maineje
use subsej2
implicit none

integer                        :: Nx, Ny
double precision,allocatable   :: A(:,:)
double precision,allocatable   :: T(:)
double precision,allocatable   :: Qx(:), Qy(:)
double precision, dimension(4) :: Tcc
integer, dimension(4)          :: typcc
character(256)                 :: formatT
integer                        :: i,j,k
double precision               :: t1,t2
logical                        :: fileis
!! estas son las variables que necesito para llamar a lapack dgesv

integer                       :: info
integer,allocatable           :: ipiv(:)

call getdata(Nx,Ny,typcc,Tcc)

!Nx = 25
!Ny = 25
print*, 'Nx = ', Nx
print*, 'Ny = ', Ny
print*, 'tycc = ', typcc
print*, 'tcc = ', Tcc

allocate(A(Nx*Ny,Nx*Ny),T(Nx*Ny),Qx(Nx*Ny),Qy(Nx*Ny))
A = 0.d0
T=0.d0

call tenerA(Nx,Ny,A,T,typcc,Tcc)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! resolver y calcular los tiempos
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
allocate(ipiv(Nx*Ny))
ipiv=0
info=19876

call cpu_time(t1)
call dgesv(Nx*Ny,1,A,Nx*Ny,ipiv,T,Nx*Ny,info)
call cpu_time(t2)

!!! calculo los flujos
call gradiente(T,Nx,Ny,Qx,Qy)

! Guardar los tiempos en algun archivo para posterior comparacion
inquire(file='tiempos.dat',exist=fileis)
if (fileis) then
  open(2,file='tiempos.dat',status='old',position='append',action='write')
else
  open(2,file='tiempos.dat',status='new',action='write')
endif
write(2,'(I5,3X,I5,3X,E20.14)'), Nx, Ny, t2-t1
close(2)



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Guardo el resultado primero como matriz y luego
! como lista para graficar en gnuplot o grace.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

open(unit=10,file='matrizT.dat')
write(formatT,'(I10)') Nx
formatT='('//trim(adjustl(formatT))//'(E12.3))'
write(10,formatT) T
close(10)

open(unit=20,file='listaT.dat')
!dx = dble( 1 / (Nx -1) )
!dy = dble( 1 / (Ny -1) )
write(20,*) "#   x   y    T   Qx   Qy"
do j=1,Ny
  do i=1,Nx
    k=i+(j-1)*Ny
!    write(20,'(I3XI3X(3(E12.4)))') i,j,T(k), Qx(k), Qy(k)
    write(20,'(5(E12.4))') (i-1)*dble( 1.d0 / (Nx -1) ), (j-1)*dble( 1.d0 / (Ny -1) ),T(k), Qx(k), Qy(k)
  enddo
  write(20,*)
enddo


end program
