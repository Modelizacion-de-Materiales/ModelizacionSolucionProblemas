module integrales
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
implicit none
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

contains

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


function INTEGRAR(metodo,F,a,b,n) result(I)
implicit none

double precision :: I

double precision, external :: F
character(255), intent(in) :: metodo
double precision, intent(in) :: a,b
integer, intent(in) :: n


select case (trim(adjustl(metodo))) 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
case ("numerico")
I = INUME(F,a,b,n)
! D1 = (1.d0/I1)*INUME(AVE,a,b,n)
!print*, 'I_numerica= ', I ! , 'D_numerica= ', D1

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
case("gauss-legendre")
I = gauleg(F,a,b,n)
!DGL = (1.d0/IGL)*gauleg(AVE,a,b,n)
!print*, 'I_gauslegendre=',IGL, 'D_gauslegendre= ' , DGL

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
case("simpson")
I = ISIMPSON(F,a,b,n)
!DSI = ( 1.d0/ISI )*ISIMPSON(AVE,a,b,n)
!print*, 'I_simpson= ',ISI, 'D_simpson= ', DSI

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end select


end function INTEGRAR


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function INUME(F,a,b,n)
implicit none

double precision, intent(in)  :: a, b
double precision, external    :: F
double precision              :: IS
double precision              :: INUME
integer, intent(in)           :: n
double precision   :: x,dx
integer :: i



dx = (b-a)/dble(n-1)



do i=1,n-1
  x=a+i*dx
  IS = IS+F(x)*dx
enddo

INUME=IS


end function INUME

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function ISIMPSON(F,a,b,n)
implicit none

double precision, external   :: F
double precision, intent(in) :: a,b
integer                      :: n
double precision             :: Spar, Simp, x, So, dx
integer                      :: i,k
double precision             :: ISIMPSON

if ( mod(n,2) /= 0 ) then
  k=n+1
else
  k=n
endif

So = F(a) + F(b)
dx = ( b - a )/dble(n)

x = a - dx
Simp = 0
do i=2,k-1,2
  x=a+i*dx
  Simp = Simp + F(x)
enddo

x=a
do i=3,k-2,2
  x=a+i*dx
  Spar=Spar + F(x)
enddo

ISIMPSON = (dx / 3.d0) * ( So + 4*Simp + 2*Spar )





end function ISIMPSON


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function gauleg(F,a,b,n)
implicit none

double precision, external   :: F
double precision, intent(in) :: a , b
integer, intent (in)         :: n

double precision             :: x, m, nn
double precision             :: r(2,n)
double precision             :: S

integer                      :: i

double precision             :: gauleg

m = (b - a)/2.d0
nn = (b + a)/2.d0
S = 0.d0
r = glnodes(n)

do i=1,n
  S = S + m*r(2,i)*F(m*r(1,i)+nn)
enddo

gauleg = S

end function gauleg

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function glnodes(n) result(r)
  implicit none
! obtenido de http://rosettacode.org/wiki/Numerical_integration/Gauss-Legendre_Quadrature#Fortran
  integer                 :: n
  double precision        :: pi = 4*atan(1.d0)
  double precision        :: r(2, n), x, f, df, dx
  integer                 :: i,  iter, k
  double precision, allocatable :: p0(:), p1(:), tmp(:)
  character(256)          :: miformat

  open(unit=1,FILE='gaus_nodes_weights.dat')

  miformat="(E10.4, 5X, E10.4)"
  write(1,*), '#  NODO     PESO'
 
  p0 = [1.d0]
  p1 = [1.d0, 0.d0]
 
  do k = 2, n
     tmp = ((2*k-1)*[p1,0.d0]-(k-1)*[0.d0, 0.d0,p0])/k
     p0 = p1; p1 = tmp
  end do
  do i = 1, n
    x = cos(pi*(i-0.25d0)/(n+0.5d0))
    do iter = 1, 10
      f = p1(1); df = 0.d0
      do k = 2, size(p1)
        df = f + x*df
        f  = p1(k) + x * f
      end do
      dx =  f / df
      x = x - dx
      if (abs(dx)<10*epsilon(dx)) exit
    end do
    r(1,i) = x
    r(2,i) = 2/((1-x**2)*df**2)
    
    write(1,miformat), r(1,i), r(2,i)

  end do


  close(1)

end function glnodes

end module integrales
