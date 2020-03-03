program E2G1
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
use integrales
use readparam
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
implicit none
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

double precision  :: a,b
double precision  :: dx,x,tol
double precision, external :: FORCE,AVE
integer           :: n,i
logical           :: barrer
character(255)      :: metodo

! parametros para el barrido
double precision :: err
logical :: FLAG
integer :: dn

double precision :: mejor_valor_I
double precision :: mejor_valor_d

double precision :: i_F, I_AVE

character(255) :: file_out

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

a=0.d0
b=30.d0
call getdata(a,b,n,barrer,tol,metodo)
! n=2  ! la idea seria leer el número de nodos de un archivo de datos.
write(*,*) "Número de puntos : ", n
write(*,*) "Método : ", metodo
dx = (b-a)/dble(n-1)

write(*,*) " hacer barrido ? ", barrer
write(*,*) "a = ", a
write(*,*) "b = ", b
write(*,*) " numero de pasos inicial : " , n
write(*,*) " tolerancia en el peor método: " , tol
write(*,*) " metodo : ", metodo

write(mifmt,'"(A",I.dat)"'
write(fileout,mifmt) metodo
write(*,*) fileout

! inicializo el barrido 
FLAG = .TRUE.
dn = 0 

mejor_valor_I = gauleg(FORCE,a,b,16)
mejor_valor_d = gauleg(AVE,a,b,16)

do while (FLAG.and.(n<10000))

   dn=int(n*(10**0.1 -1)+1)
   n=n+dn
   I_F=INTEGRAR(metodo,FORCE,a,b,n)
   I_AVE = (1/I_F)*INTEGRAR(metodo,AVE,a,b,n)

   err = abs( ( I_F - mejor_valor_I)/mejor_valor_I )
   
   if (err < tol ) then
     FLAG = .FALSE.
   endif


end do



end program E2G1


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function FORCE(z)
implicit none

double precision , intent(in)   :: z
double precision                :: F
double precision                :: FORCE

F = 200.d0 * ( z / (5 + z) )* exp ( -2.d0*z / 30.d0 ) 
FORCE = F 


end function FORCE

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function AVE(x)
implicit none

double precision, intent (in)  :: x
double precision               :: AVE
double precision, external     :: FORCE

AVE = x*FORCE(x)

end function AVE
