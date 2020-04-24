module basefunctions
implicit none

contains


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! La siguiente es una simple funcion para evaluar polinomios. 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function mipolyval(N,X,g,P) result(miP)
implicit none

integer:: N, g     ! respectivamente, el numero de puntos y el grado del polinomio.
double precision :: X(N)  !  valores donde evaluar. 
double precision :: P(g)  ! coeficeintes del polinomio, 
                          ! P(x) = P(1)*x^(g-1) + ... P(g-1)*x + P(g) 
double precision :: miP(N) ! evaluaciones de P(X)
integer :: i, j

miP=0.d0

do i=1,g
  miP=miP+P(i)*X**(g-i)
enddo


end function


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! La siguiente subrutina entrega la evaluación de una spline
!  en la serie de puntos pedida.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function evalspline(N,Xdat,P,Neval,evalx) result(evaly)
implicit none

integer :: N, Neval  ! es el numero de puntos que determinan los intervalos
                     ! y el numero de lugares donde evaluar.
double precision :: Xdat(N)  ! son los puntos que determinan los intervalos.
double precision :: P(N-1,4) ! son los coeficientes del polinomio
double precision :: evalx(Neval)
double precision :: evaly(Neval)
double precision :: temp(1),xtemp(1)
!double precision :: mipolyval

integer :: i, j


evaly=0.d0

!  1 < i < Neval
!  1 < j < Ndat

j=1
do i=1,Neval
do j=1,N-1

  if ( (evalx(i)>=Xdat(j) ) .and. ( evalx(i)<Xdat(j+1)) ) then
    xtemp(1)=evalx(i)-Xdat(j)
    temp=mipolyval(1,xtemp,size(P,2),P(j,:))
    evaly(i)=temp(1)
  endif

enddo
enddo
xtemp(1)=evalx(Neval)-Xdat(N-1)
temp=mipolyval(1,xtemp,size(P,2),P(N-1,:))
evaly(Neval)=temp(1)
end function evalspline

!!!MDF_DERIVAR
!function derivarnum(N,XY) result(dY)
!implicit none
!integer,intent(in) :: N
!double precision, intent(in) :: XY(N,2)
!double precision, intent(out) :: dy(N)
!
!integer :: i,j

!dy=0.d0

!dy(1)=(XY(2,2)-XY(1,2))/(XY(2,1)-XY(1,1))
!dy(N)=(XY(N,2)-XY(N-1,2))/(XY(N,1)-XY(N-1,1))

!do i=2,N-1
!
!  dY(i)=(XY(i+1,2)-2.d0*XY(i,2)+XY(i-1,2))/( XY(i+1,1)-XY(i-1,1) )
!
!enddo

!end function derivarnum


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!! Funcion para generar los splines cubicos con condiciones naturale 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function misplinesc(N,XY) result(P)
use datahandle
implicit none

integer, intent(in)  :: N
double precision, intent(in)  :: XY(N,2)
double precision :: P(N-1,4) ! matriz de coeficientes. 
double precision :: H(N-1)  ! tamanos de intervalos,
double precision :: Y(N)    ! Vector de cargas.
double precision :: M(N,N)  ! Matriz de coeficientes, derivadas segundas.

integer :: i, j             ! contadores.

! variables para resolucion.
!!!!!!!!!!! variables para lapack
double precision  :: MAT(N,N),VC(N),DIAG(N),DIAGL(N-1),DIAGU(N-1)
integer :: INFO
integer :: IPIV(N)

!!! inicializo las variables. 
P=0.d0
H=0.d0
Y=0.d0
M=0.d0
MAT=0.d0
VC=0.d0
DIAG=0.d0
DIAGL=0.d0
DIAGU=0.d0

INFO=1912
IPIV=0

!!! calculo los tamanos de intervalo. 
do i=1,N
  H(i)=XY(i+1,1)-XY(i,1)
enddo 
call guardamatriz(N,2,XY,'ListaXY.dat','overwrite')

!!!MDF_HACE_Y
do i=2,N-1
  Y(i)=3.d0*( (XY(i+1,2)-XY(i,2))/H(i) - (XY(i,2)-XY(i-1,2))/H(i-1) )
enddo
call guardamatriz(N,1,Y,'VectorY.dat','overwrite')

!!! MDF_HACE_MATRIZ
M(1,1)=1.d0
M(N,N)=1.d0
do i=2,N-1
  M(i,(/i-1,i,i+1/))=(/ H(i-1) , 2.d0*( H(i)+H(i-1) ) , H(i)  /)
enddo
call guardamatriz(N,N,M,'Matriz.dat','overwrite')
! actualizo la matriz que voy a mandar a la subrutina y el vector de cargas
MAT=M
VC=Y
!!! MDF_DIAGONALES
do i=1,N
  DIAG(i)=MAT(i,i)
enddo
do i=1,N-1
  DIAGU(i)=MAT(i,i+1)
  DIAGL(i)=MAT(i+1,i)
enddo

!!! MDF_RESUELVE
call dgtsv(N,1,DIAGL,DIAG,DIAGU,VC,N,INFO)
!P(:,2)=VC(1:N-1)

call guardamatriz(N,1,VC,'VectorB.dat','overwrite')


do i=1,N-1
  P(i,1)=(1.d0/3.d0)*(VC(i+1)-VC(i))/H(i)
  P(i,2)=VC(i)
  P(i,3)=(XY(i+1,2)-XY(i,2))/H(i) - P(i,2)*H(i) - P(i,1)*H(i)**2
enddo

P(:,4)=XY(1:N-1,2)
!call guardamatriz(N-1,1,P(:,1),'coeficientesA.dat','overwrite')
!call guardamatriz(N-1,1,P(:,3),'coeficientesC.dat','overwrite')
call guardamatriz(N-1,4,P,'Polinomios.dat','overwrite')

end function misplinesc


end module
