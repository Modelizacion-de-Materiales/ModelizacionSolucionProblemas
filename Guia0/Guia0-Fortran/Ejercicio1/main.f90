program main
use datahandle
use basefunctions

!!!MDF_DECLARA
implicit none
double precision, allocatable :: XY(:,:)
double precision, allocatable :: P(:,:)                                          
double precision, allocatable :: evalx(:) ! voy a evaluar el pol.
double precision :: evaldx ! voy a evaluar el pol.
double precision, allocatable :: evaly(:) ! voy a evaluar el pol.
integer :: N , evalN   ! son el numero de datos y el numero de evaluaciones 
                       ! del spline. vienen dados en datos.dat

integer:: D,i,j
character ( 256 )::Nstring

double precision ,allocatable  :: XYspline(:,:)

! estas variables son auxiliares para usar en la lectura del archivo de
! parametros. 

character (256) :: filein
character (256) :: fileval
character (256) :: datafile

!!!MDF_PR2OGRAMA

!!!MDF_LEE_PARAMS
! Los parametros que quiero leer de un archivo son:
! N :  numero de puntos de la lista de datos. 
! D : Dimensión de los datos. es redundante, en general va a valer 2.
! evalN : numero de puntos en los que voy a evaluar el spline resultante. 
! filein : archivo donde estan los datos.
! fileval : archivo con la evaluacion de la función. 
! 
!!!
print*, ' llamando a lectura de parametros ' 
call leerparams(N,D,evalN,filein,fileval)

XY=leerdatos(N,D,filein)   ! leo dos columnas de datos

N=size(XY,1)
D=size(XY,2)
write(Nstring,*) N, D
Nstring=trim(Nstring)

stop



!!! MDF_HACE_P
! directamente, con los datos mando a hacer los splines.
allocate(P(N-1,4))
P=misplinesc(N,XY)

!!! MDF_EVALUA_SPLINES
allocate(evalx(10))  ! 10 puntos por intervalo
allocate(evaly(10))  ! 10 puntos por intervalo
  call guardamatriz(1,1,(/0.d0/),'listasalida.dat','firstline')
do i=1,N-1 
  evalx=(/(XY(i,1)+j*(XY(i+1,1)-XY(i,1))/10.d0, j=1,9 )/)
  evaly=mipolyval(size(evalx),evalx-XY(i,1),4,P(i,:))
  call guardamatriz(size(evalx),2,(/evalx,evaly/),'listasalida.dat','append')
enddo


!!! otra forma de evaluar el polinomio obtenido por spline.
deallocate(evalx,evaly)
allocate(XYspline(101,2))
XYspline(:,1)=(/ (XY(1,1)+j*0.03, j=0,101) /)
XYspline(:,2)=evalspline(N,XY(:,1),P,size(XYspline(:,1)),XYspline(:,1))
print*, size(XYspline,1),size(XYspline,2)

call guardamatriz(size(XYspline,1),size(XYspline,2),XYspline,'otralistasalida.dat','overwrite')



end program main

!subroutine leerparams(N,D,evalN,filein,fileval)
subroutine leerparams(N,D,evalN,filein,fileval)
implicit none
integer :: N, D, evalN
character(*) :: filein, fileval
character(256) :: tag,valor,line
integer:: iostatus

open(500,file='PARAMS',status='old',action='read')
iostatus=0
do while (iostatus == 0 )
  read(500,'(A)',iostat=iostatus) line
  if ( LEN(trim(adjustl(line)) ) == 0 ) then
    cycle
  endif
  read(line,*) tag, valor
  select case ( trim(adjustl(tag)) )
  case ('N')
     read(valor,*) N
  case ('D') 
     read(valor,*) D
  case ('evalN')
     read(valor,*) evalN
  case ('filein')
     filein = valor
  case ('fileval')
     fileval = valor
  endselect

enddo


end subroutine
