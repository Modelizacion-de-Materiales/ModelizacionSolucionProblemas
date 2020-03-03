program mainej
use dataread
use timevolv

implicit none

integer                     :: N, method
double precision                        :: lambda,KX
double precision                        :: L
double precision,allocatable            :: C(:,:),T(:)
integer                                 :: i,j
double precision                        :: dx, dt, tmax
double precision                        :: T0(3)
double precision                        :: tol
character(256)                          :: formato
!A = 0.d0
!B = 0.d0
!forall (i=1:N) B(i,i) = 1.d0
!forall (i=1:N) A(i,i) = 1.d0

call getdata(L,dx,dt,tmax,T0,KX,lambda,METHOD,tol)

N = nint(L/dx +1)
write(formato,'(I10)') N
formato='('//trim(adjustl(formato))//'(E12.4))'

allocate(C(N,N),T(N))
! ahora tengo que armar la condicion inical con el vector T0
T((/1,N/)) = T0((/1,3/))
T((/(i,i=2,N-1)/)) = T0(2)



call matrmkr(N,lambda,METHOD,C)

! Escribo en pantalla como me queda la matriz
print* , 'C = '
do i=1,N
write(*,formato) C(i, (/ (j,j=1,N) /) )
write(*,*)
enddo

! por último tengo que efectivizar la evolución temporal

call  pasartiempo(N,T,dt,tmax,tol,C)

end program mainej
