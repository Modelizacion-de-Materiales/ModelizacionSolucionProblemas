module readparam

implicit none

contains

subroutine getdata(xo,xf,n,barrer,tol,metodo)
implicit none

!estas bariables son los parametros que hay que leer del archivo
integer :: n
logical :: barrer
double precision :: tol,xo,xf
character(255):: metodo

! variables internas para trabajar
character(255):: line
character(255):: linehead 
character(255):: linedata
character(255):: linetail

integer :: iostatus, poseq, posco, nume
integer :: fileunit=100
integer :: errounit =1000

open(unit = fileunit, file = 'DATIN', action = 'read' , status = 'old')
open( unit = errounit, file='DATIN_ERROR',action = "write")

do 

  read(fileunit,'(A)',iostat=iostatus) line
  if (iostatus /=0 ) then
    exit
  endif 

! leo la linea
  line = trim(adjustl(line))

! si es un comentario la paso de largo
  if (line(1:1)=='#') then
    cycle
  endif

  poseq = index(line,'=')
  posco = index(line,'#')
! seguramente este código puede mejorarse, ya que hasta aquí solo lo estoy haciendo para obtener un parámetro. 
  if ( (poseq == 0 ).and.( posco == 0 ) ) then 
     cycle
!    linehead= trim(adjustl(line))
! en este caso no hay definiciones de parametros.
  else if ( ( poseq /=0 ).and.( posco /=0 ).and.(poseq < posco ) ) then
    linehead = trim( adjustl(line(:poseq-1) ) )
    linedata = trim( adjustl(line(poseq+1:posco-1) ) )
  else if ( (poseq /=0 ).and.(posco==0) ) then
    linehead = trim(adjustl(line(1:poseq-1)))
    linedata = trim(adjustl(line(poseq+1:)))
  else if (posco /=0 ) then
      linehead = trim(adjustl(line(:posco-1)))
      linedata = ''    
  else
    cycle
  end if


  select case (linehead)
        case ('N')
           read(linedata,*) n
        case ('METODO')
           read(linedata,*) metodo
           metodo = trim(adjustl(metodo))
        case ('BARRER')
           read(linedata,*) barrer
        case ('TOLERA') 
           read(linedata,*) tol
        case('x0')
           read(linedata,*) xo
        case('xF') 
           read(linedata,*) xf
           
           
  end select

end do

  write(*,*), 'N = ', n
  write(*,*), 'Metodo = ', metodo

  CLOSE (fileunit)
  CLOSE (errounit)


end subroutine getdata

end module readparam
