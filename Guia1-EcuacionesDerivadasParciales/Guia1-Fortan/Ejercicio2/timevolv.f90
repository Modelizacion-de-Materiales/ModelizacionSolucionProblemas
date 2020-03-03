module timevolv
implicit none

contains

subroutine pasartiempo(N,Temp,dt,tmax,tol,C)
implicit none

integer, intent(in)             :: N
double precision                :: Temp(N)
double precision, intent(in)    :: tmax,dt
double precision, intent(in)    :: tol

double precision                :: t
double precision                :: flujoi,flujod

double precision                :: C(N,N)
integer   :: X(N), i

! abro el archivo donde voy a guardar las temperaturas.
open(unit=100,file='TEMP.dat')
open(unit=200,file='FLUX.dat')

t=0.d0
X=(/ (i, i=1,N) /)
! escribo la condición inicial
flujoi=Temp(2)-Temp(1)
flujod=Temp(N)-Temp(N-1)
do i=1,N
!  write(100,'(E8.3,3X,I6,3X,E12.5,3X,E12.5,3X,E12.5)'),&
  write(100,'(E8.3,3X,I6,3X,E12.5)'),&
                  & t, i , Temp(i) !,flujoi,flujod
enddo
write(200,'(E8.3,3X,E12.5,3X,E12.5)'), t,flujoi, flujod
!write(100,*)
!write(100,*)

do while (t <= tmax )
  t=t+dt
  Temp = matmul(C,Temp)  
                         
  write(100,*)
  write(100,*)

  flujoi=Temp(2)-Temp(1)
  flujod=Temp(N)-Temp(N-1)


  do i=1,N
!    write(100,'(E8.3,3X,I6,3X,E12.5,3X,E12.5,3X,E12.5)'),&
    write(100,'(E8.3,3X,I6,3X,E12.5)'),&
                & t, i ,Temp(i) !,flujoi,flujod
  enddo
  write(200,'(E8.3,3X,E12.5,3X,E12.5)'), t,flujoi, flujod

!  write(100,*)
!  write(100,*)
  
enddo

close(100)
close(200)

end subroutine

subroutine matrmkr(N,lambda,method,C)
implicit none

integer, intent(in) :: N, method
double precision, intent (in)   :: lambda
double precision, intent(inout) :: C(N,N)
double precision   :: A(N,N), B(N,N)
integer             :: i,j

! variables extra para usar la subrutina lapack de inversion
integer :: lda
integer, allocatable :: ipiv(:)
integer :: lwork
double precision,allocatable :: work(:)
integer :: info


forall ( i = 1:N, j = 1:N ) A(i,j) = (i/j) * (j/i)
forall ( i = 1:N, j = 1:N ) B(i,j) = (i/j) * (j/i)

!enddo

C = 0.d0

select case (method)
case (1)
  ! en este caso quiero resolver por el método explícito.
  do i=2,N-1
    B(i,(/i-1,i,i+1/) ) = (/ lambda , 1.d0-2.d0*lambda , lambda /)
  enddo
case (2)
  ! en este caso resuelvo el método implicito
    do i=2,N-1
    A(i,(/i-1,i,i+1/) ) = (/ -lambda , 1.d0+2.d0*lambda , -lambda /)
    enddo
case (3)
  ! en este ultimo caso resuelvo el método C-N
  do i=2,N-1
     B(i,(/i-1,i,i+1/) ) = (/ lambda , 2.d0*(1.d0-lambda) , lambda /)
     A(i,(/i-1,i,i+1/) ) = (/ -lambda , 2.d0*(1.d0+lambda) , -lambda /)
  enddo

endselect

! inicio las variables para poder invertir la matriz
lda = N
allocate(ipiv(N),work(N))
ipiv=0
lwork=N
work=0.d0
info=1944
call DGETRF(N,N,A,LDA,IPIV,INFO)
call DGETRI( N, A, LDA, IPIV, WORK, LWORK, INFO )



C=matmul(A,B)

end subroutine


end module
