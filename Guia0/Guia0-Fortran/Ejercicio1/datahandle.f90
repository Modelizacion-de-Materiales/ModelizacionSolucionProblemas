module datahandle 
implicit none

contains 

function leerdatos(N,D,fromfile) result(A)
implicit none

character(LEN=256) :: line
integer  :: i=0
integer  :: iostatus
integer,intent(IN)  :: N  ! numero de puntos.
integer,intent(IN) :: D  ! dimensionalidad de los datos
double precision :: A(N,D)
character(*) :: fromfile


print*, 'leyendo desde ', fromfile
open(UNIT=1,FILE=fromfile,status='old',action='read')

do i=1,N
  read(1,'(A)',iostat=iostatus) line
  if (iostatus /= 0) then
    exit
  endif
  read(line,*) A(i,:)
enddo
 
 ! descomentar solo para propositos de debugeo
 !  write (*,*) "=========================="

end function



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Subrutina para guardar matrices cuadradas.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine guardamatriz(N,M,A,filename,miaction)
implicit none

integer :: N,M
double precision :: A(N,M)
character (256) :: myfmt
character (*):: filename,miaction
integer :: U, i
logical :: file_exist
U=200

!
! tengo que fijarme si el archivo que quiero escribir FILENAME existe.
! si existe me fijo en MIACTION, si voy a hacer append o reescrivir.
!

inquire(file=filename,exist=file_exist)

write(myfmt,'(I10)') M
myfmt='('//trim(adjustl(myfmt))//'(E12.3))'
!print*,'se guarda una matriz en el archivo ', filename
!print*, 'formato de la matriz:', myfmt

if (miaction == 'firstline' ) then
  open(unit=U,file=filename, action='write')
  write(U,*) '############# ' 
  return
else if ( file_exist .AND. miaction /= 'overwrite' ) then
  open(unit=U,file=filename,status='old',position='append',action='write')
else if  (file_exist .AND. miaction == 'overwrite' ) then
  open(unit=U,file=filename,action='write')
else if (.NOT. file_exist) then
  open(unit=U,file=filename,status='new',action='write')
endif

  
do i=1,N
  write(U,myfmt) A(i,:)
enddo
close(U)

end subroutine

end module
