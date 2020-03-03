
integer,allocatable :: kA(:)
integer,allocatable :: kB(:)
integer,allocatable :: kC(:)
integer,allocatable :: kD(:)
integer,allocatable :: kV(:)
double precision, allocatable :: A(:,:),B(:)
integer             :: Nx=4,Ny=4
integer             :: i,k, j
double precision    :: Tcc(4)
integer             :: typcc(4)
double precision    :: dx,dy,beta
double precision, allocatable :: T(:,:)
character(256)      :: formatA,formatB

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! variables para la aplicación de la subrutina de solución 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
integer                       :: info,lda,ldb,n,nrhs
integer,allocatable           :: ipiv(:)
double precision, allocatable :: AINOUT(:,:)


allocate(kA(Nx-2),kB(Nx-2))
allocate(kC(Ny-2),kD(Ny-2))
allocate(kV(4))
allocate(A(Nx*Ny,Nx*Ny),B(Nx*Ny))

A = 0.d0
B = 0.d0
dx=1.d0/dble(Nx-1)
dy=1.d0/dble(Ny-1)
beta = dy/dx

typcc = (/1 , 1 , 2 , 1 /)
Tcc = (/75.d0, 50.d0, 0.d0 , 100.d0/)
print*,'Tcc = ', Tcc
kV=(/1,Nx,(Nx-1)*Ny+1,Nx*Ny/)
kA=(/(i,i=Nx+1,(Nx-2)*Ny+1,Nx)/)
kB=(/(i,i=2*Nx,(Nx-1)*Ny,Nx)/)
kC=(/(i,i=2,Nx-1)/)
kD=(/(i,i=(Nx-1)*Ny+1+1,Nx*Ny-1)/)

open(unit=1,file='matrizA.dat')
write(formatA,'(I10)') Nx*Ny
formatA='('//trim(adjustl(formatA))//'(E12.3))'
print*,formatA


do k=1,Nx*Ny

  if ( k == kV(1) ) then

    if ( (typcc(1) == 1) .and. (typcc(3) == 1)) then
      A(k,k) = 1.d0
      b(k) = (Tcc(1)+Tcc(3))/2.d0
    elseif ( typcc(1) == 1 ) then
      A(k,k) = 1.d0
      b(k) = Tcc(1)
    elseif (typcc(3) == 1) then
      A(k,k) = 1.d0
      b(k) = Tcc(3)
    elseif  ( (typcc(1) == 2) .and. (typcc(3) == 2))
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
    elseif  ( (typcc(2) == 2) .and. (typcc(3) == 2))
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
    elseif  ( (typcc(2) == 2) .and. (typcc(4) == 2))
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
    elseif  ( (typcc(1) == 2) .and. (typcc(4) == 2))
      A(k,(/k-Nx,k,k+1/) ) = (/2.d0*beta**2, -2.d0*(1.d0 - beta**2), 2.d0/)
      B(k) = -2.d0*dy*Tcc(4)*beta**2 + 2.d0*dx*Tcc(1)
    endif

  elseif ( any( k == kA ) ) then
    if (typcc(1)==1)
      A(k,k) = 1
      B(k)   = Tcc(1)
    else
      A(k,(/k-Nx,k,k+1,k+Nx/)) = (/beta**2,-2.d0*(1.d0+beta**2), 2.d0, beta**2 /)
      B(k) = 2*dx*Tcc(1)
    endif

  elseif ( any( k == kB ) ) then
    A(k,k) = 1
    B(k) = Tcc(2)
    if (typcc(2)==1)
      A(k,k) = 1
      B(k)   = Tcc(2)
    else
      A(k,(/k-Nx,k-1,k,k+Nx/)) = (/beta**2,2.d0,-2.d0*(1.d0+beta**2), beta**2 /)
      B(k) = -2*dx*Tcc(2)
    endif

  elseif ( any( k == kC ) ) then

    if (typcc(3)==1)
      A(k,k) = 1
      B(k)   = Tcc(2)
    else
      A(k,(/k-1,k,k+1,k+Nx/)) = (/1.d0,-2.d0*(1.d0+beta**2), 1.d0, 2* beta**2 /)
      B(k) = -2*dy*Tcc(2)*beta**2
    endif

  elseif ( any( k == kD ) ) then
    A(k,k) = 1
    B(k) = Tcc(4)
    if (typcc(4)==1)
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

open(unit=2,file='matrizT.dat')
write(2,'("condicion inicial"/3(E12.3))')  B

INFO = 10
nrhs = 1 
lda = Nx*Ny
ldb = lda
allocate(ipiv(Nx*Ny))
!ipiv=0

print*, ' a punto de hacer la inversion con dgesv'

call DGESV( Nx*Ny, NRHS, A, LDA, IPIV, B, LDB, INFO )

write(2,'(/"resultado"/3(E12.3))') B



! la matriz de temperaturas resultado.
!allocate(T(Nx*Ny,Nx*Ny))
  
  





end program

