module subsej2
implicit none

contains

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! subrutina para calcular el gradiente de la temperatura (flujos)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


subroutine gradiente(T,Nx,Ny,Qx,Qy)
implicit none

integer, intent(in)            :: Nx, Ny
double precision, intent(in)   :: T(Nx*Ny)
double precision               :: dx, dy
double precision               :: Qx(Nx*Ny), Qy(Nx*Ny)
double precision               :: fe
integer                        :: i,j,k
integer                        :: ka(Nx-2),kb(Nx-2),kc(Ny-2),Kd(Ny-2),kv(4)

dx=1.d0/dble(Nx-1)
dy=1.d0/dble(Ny-1)
Qx = 0.d0
Qy = 0.d0

kV=(/1,Nx,(Nx-1)*Ny+1,Nx*Ny/)
kA=(/(i,i=Nx+1,(Nx-2)*Ny+1,Nx)/)
kB=(/(i,i=2*Nx,(Nx-1)*Ny,Nx)/)
kC=(/(i,i=2,Nx-1)/)
kD=(/(i,i=(Nx-1)*Ny+1+1,Nx*Ny-1)/)
do k=1,Nx*Ny
  if ( k == kV(1) ) then
    Qx(k) = (T(k+1 )-T(k))/dx
    Qy(k) = (T(k+Nx)-T(k))/dx
  elseif (k == kV(2)) then
    Qx(k) = (T(k )-T(k-1))/dx
    Qy(k) = (T(k+Nx)-T(k))/dx
  elseif ( k == kV(3) ) then
    Qx(k) = ( T(k+1) - T(k) ) / dx
    Qy(k) = ( T(k) - T(k-1) ) / dy
  elseif ( k == kV(4) ) then
    Qx(k) = ( T(k) - T(k-1) ) / dx
    Qy(k) = ( T(k) - T(k-1) ) / dy
  elseif ( any(k == kA) ) then
    Qx(k) = ( T(k+1)-T(k) ) / dx
    Qy(k) = ( T(k+Nx)-T(k-Nx) ) / ( 2.d0*dy )
  elseif ( any(k == kB) ) then
    Qx(k) = ( T(k) - T(k-1) )/dx
    Qy(k) = ( T(k+Nx)-T(k-Nx) ) / ( 2.d0*dy )
  elseif ( any( k == kC ) ) then
    Qx(k) = ( T(k+1) - T(k-1) )/(2.d0*dx)
    Qy(k) = ( T(k+Nx) - T(k) ) / dy
  elseif ( any( k == kD ) ) then
    Qx(k) = ( T(k+1) - T(k-1) )/(2.d0*dx)
    Qy(k) = ( T(k) - T(k-Nx) ) / dy
  else  ! cualquiera de los puntos internos
    Qx(k) = ( T(k+1) - T(k-1) )/(2.d0*dx)
    Qy(k) = ( T(k+Nx) - T(k-Nx) ) / ( 2.d0*dy )
  endif



enddo

Qx = -Qx
Qy = -Qy

end subroutine gradiente

subroutine getdata(Nx,Ny,tycc,tcc)
implicit none
integer          :: Nx, Ny
character(6)     :: filein='DATIN'
integer          :: tycc(4)
double precision :: tcc(4)
character(256)   :: line
character(256)   :: linehead,linecontent
integer          :: iostatus,pos
integer          :: i

open(unit=50,file=filein,status='old',action='read')
iostatus = 0

do while (1 == 1)
  
  read(50,'(A)',iostat=iostatus) line
  if (iostatus /= 0) then
    exit
  endif

  pos = index(line,"=")
  linehead = line(1:pos-1)
  linecontent = line(pos+1:)
  linehead = trim(adjustl(linehead))
  linecontent = trim(adjustl(linecontent))

  if (linehead=='NX') then
    read(linecontent,*) Nx
!    print*, 'Nx = ', Nx
  elseif (linehead=='NY') then
    read(linecontent,*) Ny
!    print*, 'Ny = ', Ny
  elseif (linehead=='TYPCC') then
    read(linecontent,*) (tycc(i),i=1,4)
!    print*, 'tycc = ', tycc
  elseif (linehead=='TCC') then
    read(linecontent,*) (tcc(i),i=1,4)
!    print*, 'tcc = ', tcc
  endif

enddo
close(50)

end subroutine


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine tenerA(Nx,Ny,A,B,typcc,tcc)
implicit none

integer,intent(in)             :: Nx, Ny
integer, intent(in)            :: typcc(4)
double precision,intent(in)    :: tcc(4)
double precision               :: dx,dy
double precision               :: A(Nx*Ny,Nx*Ny)
double precision               :: B(Nx*Ny)

integer                        :: i,j,k
integer                        :: ka(Nx-2),kb(Nx-2),kc(Ny-2),Kd(Ny-2),kv(4)

double precision               :: beta
character(256)                 :: formatA

! variables para la aplicación de la subrutina de solución 



A = 0.d0
B = 0.d0
dx=1.d0/dble(Nx-1)
dy=1.d0/dble(Ny-1)
beta = dy/dx

kV=(/1,Nx,(Nx-1)*Ny+1,Nx*Ny/)
kA=(/(i,i=Nx+1,(Nx-2)*Ny+1,Nx)/)
kB=(/(i,i=2*Nx,(Nx-1)*Ny,Nx)/)
kC=(/(i,i=2,Nx-1)/)
kD=(/(i,i=(Nx-1)*Ny+1+1,Nx*Ny-1)/)

open(unit=1,file='matrizA.dat')
write(formatA,'(I10)') Nx*Ny
formatA='('//trim(adjustl(formatA))//'(E12.3))'

! Loop principal. recorro nodo por nodo y veo como se llena la matriz
do k=1,Nx*Ny

  if ( k == kV(1) ) then

    if ( (typcc(1) == 1) .and. (typcc(3) == 1)) then
      A(k,k) = 1.d0
      B(k) = (Tcc(1)+Tcc(3))/2.d0
    else if ( typcc(1) == 1 ) then
      A(k,k) = 1.d0
      B(k) = Tcc(1)
    else if (typcc(3) == 1) then
      A(k,k) = 1.d0
      B(k) = Tcc(3)
    else if  ( (typcc(1) == 2) .and. ( typcc(3) == 2 ) ) then
      A(k,(/k,k+1,k+Nx/) ) = (/ -2.d0*(1.d0 - beta**2) , 2.d0 , 2.d0 /)
      B(k) = 2*dy*Tcc(3)*beta**2 + 2*dx*Tcc(1)
    endif

  elseif ( k == kV(2) ) then
    
    if ( (typcc(2) == 1) .and. (typcc(3) == 1)) then
      A(k,k) = 1.d0
      b(k) = (Tcc(2)+Tcc(3))/2.d0
    elseif ( typcc(2) == 1 ) then
      A(k,k) = 1.d0
      b(k) = Tcc(2)
    elseif (typcc(3) == 1) then
      A(k,k) = 1.d0
      b(k) = Tcc(3)
    elseif  ( (typcc(2) == 2) .and. (typcc(3) == 2)) then
      A(k,(/k-1,k,k+Nx/) ) = (/2.d0, -2.d0*(1.d0 - beta**2) , 2.d0 /)
      B(k) = 2.d0*dy*Tcc(3)*beta**2 - 2.d0*dx*Tcc(1)
    endif

  elseif ( k == kV(4) ) then
    A(k,k) = 1.d0
    b(k) = (Tcc(2)+Tcc(4))/2.d0

    if ( (typcc(1) == 1) .and. (typcc(4) == 1)) then
      A(k,k) = 1.d0
      b(k) = (Tcc(2)+Tcc(4))/2.d0
    elseif ( typcc(2) == 1 ) then
      A(k,k) = 1.d0
      b(k) = Tcc(2)
    elseif (typcc(4) == 1) then
      A(k,k) = 1.d0
      b(k) = Tcc(4)
    elseif  ( (typcc(2) == 2) .and. (typcc(4) == 2)) then
      A(k,(/k-Nx,k-1,k/) ) = (/2.d0*beta**2,2.d0, -2.d0*(1.d0 - beta**2)/)
      B(k) = -2.d0*dy*Tcc(2)*beta**2 - 2.d0*dx*Tcc(4)
    endif


  elseif ( k == kV(3) ) then
    A(k,k) = 1.d0
    b(k) = (Tcc(1)+Tcc(4))/2.d0
    if ( (typcc(1) == 1) .and. (typcc(4) == 1)) then
      A(k,k) = 1.d0
      b(k) = (Tcc(1)+Tcc(4))/2.d0
    elseif ( typcc(1) == 1 ) then
      A(k,k) = 1.d0
      b(k) = Tcc(1)
    elseif (typcc(4) == 1) then
      A(k,k) = 1.d0
      b(k) = Tcc(4)
    elseif  ( (typcc(1) == 2) .and. (typcc(4) == 2)) then
      A(k,(/k-Nx,k,k+1/) ) = (/2.d0*beta**2, -2.d0*(1.d0 - beta**2), 2.d0/)
      B(k) = -2.d0*dy*Tcc(4)*beta**2 + 2.d0*dx*Tcc(1)
    endif

  elseif ( any( k == kA ) ) then
    if (typcc(1)==1) then
      A(k,k) = 1
      B(k)   = Tcc(1)
    else
      A(k,(/k-Nx,k,k+1,k+Nx/)) = (/beta**2,-2.d0*(1.d0+beta**2), 2.d0, beta**2 /)
      B(k) = 2*dx*Tcc(1)
    endif

  elseif ( any( k == kB ) ) then
    A(k,k) = 1
    B(k) = Tcc(2)
    if (typcc(2)==1) then
      A(k,k) = 1
      B(k)   = Tcc(2)
    else
      A(k,(/k-Nx,k-1,k,k+Nx/)) = (/beta**2,2.d0,-2.d0*(1.d0+beta**2), beta**2 /)
      B(k) = -2*dx*Tcc(2)
    endif

  elseif ( any( k == kC ) ) then

    if (typcc(3)==1) then
      A(k,k) = 1
      B(k)   = Tcc(2)
    else
      A(k,(/k-1,k,k+1,k+Nx/)) = (/1.d0,-2.d0*(1.d0+beta**2), 1.d0, 2*beta**2 /)
      B(k) = 2*dy*Tcc(3)*beta**2
    endif

  elseif ( any( k == kD ) ) then
    A(k,k) = 1
    B(k) = Tcc(4)
    if (typcc(4)==1) then
      A(k,k) = 1
      B(k)   = Tcc(4)
    else
      A(k,(/k-Nx,k-1,k,k+1/)) = (/2*beta**2,1.d0,-2.d0*(1.d0+beta**2), 1.d0  /)
      B(k) = -2*dy*Tcc(4)*beta**2
    endif


  else

    A(k,(/k-Nx,k-1,k,k+1,k+Nx/)) = (/ beta**2 , 1.d0, -2.d0*(beta**2+1.d0), 1.d0, beta**2 /)

  endif

  write(1,formatA) A(k,(/(i,i=1,Nx*Ny)/))
!  print*, A(k,(/(i,i=1,Nx*Ny)/))

enddo  


close(1)
! ahora procedo a resolver
! para eso necesito definir un par de cosas. 

end subroutine tenerA

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  

end module subsej2
