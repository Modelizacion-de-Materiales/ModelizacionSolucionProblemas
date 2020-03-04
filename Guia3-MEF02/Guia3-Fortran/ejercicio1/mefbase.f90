module mefbase
implicit none

 contains

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! solver
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine mdfsolver(N,K,U,F,r,s,nr)
implicit none

integer, intent(in) :: N ,nr
integer, intent(in) :: r(nr), s(N-nr)
double precision, intent(in) :: K(N,N)
double precision, intent(inout) :: U(N),F(N)
! auxiliares para la solución del sistema.
double precision:: Kred(nr,nr),b(nr)
! lo que tengo que hacer es la cuenta típica
! U(r) = inv(K(r,r))*(F(r)-K(r,s)*U(s))
integer :: IPIV(nr) 
integer :: INFO = 123

Kred=K(r,r)
b = F(r) - matmul(K(r,s),U(s))

call dgesv (nr, 1, Kred, nr, IPIV, b, nr, INFO)

U(r)=b
F(s) = matmul(K(s,:),U)

end subroutine mdfsolver
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! ENSAMBLE
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine ensamble(gl,nnxe,nn,MC,M,Kloc)
    ! ensambla un único elemento
implicit none

integer, intent(in) :: gl, nnxe, nn
integer, intent(in) :: MC(nnxe)
double precision, intent(in) :: Kloc(nnxe*gl,nnxe*gl)
double precision, intent(inout) :: M(nn*gl,nn*gl)

integer :: i, j, ni,nj


do i=1,nnxe
    ni=MC(i)
    do j=1,nnxe
      nj=MC(j)
      M( (ni-1)*gl+1:ni*gl , (nj-1)*gl+1:nj*gl ) = &
                            M( (ni-1)*gl+1:ni*gl , (nj-1)*gl+1:nj*gl ) + &
                            Kloc((i-1)*gl+1:i*gl , (j-1)*gl+1:j*gl )                        
    enddo
enddo


end subroutine ensamble
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! La proxima subrutina lee el msh, en formato
! a mano, en archivos DATMSH. 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine leermimsh(gl,nn,nnxe,ne,MN,MC)
implicit none
integer, intent(out) :: gl
integer, intent(out) :: nn
integer, intent(out) :: nnxe 
integer, intent(out) :: ne

double precision, intent(inout),allocatable :: MN(:,:)
integer, intent(inout),allocatable :: MC(:,:)

character(255) :: line
character(255) :: linehead
character(255) :: linedata
character(255) :: linetail
character(255) :: fmt

integer :: iostatus, poseq,posco, nume
integer :: mshunit = 100
open(unit=mshunit,file='DATMSH',action='read',status='old')


do

  read(mshunit,'(A)',iostat=iostatus) line
  if (iostatus /= 0) then
    exit
  endif
  line=trim(adjustl(line))
  if (line(1:1)=='#') then
    cycle
  endif
  
  poseq = index(line,'=')
  posco = index(line,'#')
  
  if ( (poseq == 0).and.(posco == 0)  )then ! esto es, si tengo un encabezado.
    linehead = trim(adjustl(line))  
  else if ( ( poseq /= 0).and.( posco /=0 ) ) then  ! esto es, si tengo la 
      ! definicion de etiqueta con
      ! commentario.
      linehead = trim(adjustl(line(:poseq-1) ) )
      linedata = trim(adjustl(line(poseq+1:posco-1)))
  else if ( poseq /= 0) then      ! esto es, etuiqueta sin comentario.
    linehead = trim(adjustl(line(1:poseq-1)))
    linedata = trim(adjustl(line(poseq+1:)))
  else if ( posco /= 0 )  then ! esto es, comentario en la línea.
      
      linehead = trim(adjustl(line(:posco-1)))
      linedata = ''
  else   ! en cualquier otro caso agarro toda la linea, pero tampoco hay igual.
        ! esto no tendría que ocirrir nunca!
        linehead = trim(adjustl(line))
        linedata =  ''
  end if

  select case (linehead)
    case ('NN') ! tener el numero de nodos
      read(linedata,*), nn
    case ('NEL','EL') ! tener el numero de elementos
      read(linedata,*), ne
    case ('GL')
      read(linedata,*), gl
    case ('NNXE') ! tener el numero de nodos por elementos
      read(linedata,*), nnxe
    case ('Elementos')
      allocate(MC(ne,nnxe))
      print*, 'a leer la matriz de conectividad, ne', ne
      poseq = 0
      do while (poseq<ne) ! leer la matriz de conectividad
    read(mshunit,'(A)'), linedata
    linedata=trim(adjustl(linedata))
    if (linedata(1:1)=='#' ) then 
      CYCLE
    else
    poseq=poseq+1
    posco=index(linedata,' ') ! encontrar el primer espacio en blanco
    read(linedata(1:posco-1),*), nume
    read(linedata(posco+1:),*) , MC(nume,:)
    endif
      enddo
    case ('Nodos')
!      !!! nota que para definir la matriz de  nodos, tengo que tener 
!      !!! nn definido
      allocate(MN(nn,3))
      print*, 'a leer la matriz de nodos, nn', nn
      poseq=0
      do while (poseq<nn)  ! leer la matriz de nodos
    read(mshunit,'(A)'), linedata
    linedata=trim(adjustl(linedata))
    if (linedata(1:1)=='#' ) then 
      CYCLE
    endif
        poseq=poseq+1
    posco=index(linedata,' ') ! encontrar el primer espacio en blanco
    read(linedata(1:posco-1),*), nume
    read(linedata(posco+1:),*) , MN(nume,:)
      enddo
     case default
      cycle
  end select
  
enddo
close(unit=mshunit)
end subroutine leermimsh
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! la próxima subrutina lee la tabla de vínculos
! de DATVIM
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine leervinc(gl,nn,nnxe,MN,MP,MVIN,XVIN,UVIN)
implicit none

integer, intent(in) :: gl, nn, nnxe
double precision, intent(in) :: MN(nn,3)

! Estas son variables internas. Matriz de VINculos, Matriz de 
! Propiedades, UVINculados
integer,allocatable :: MVIN(:,:),XVIN(:,:)
double precision,allocatable  :: MP(:),UVIN(:)
integer, allocatable :: r(:), s(:)

! variable de los números de vínculos.
integer :: nr , ns,auxr(nn*gl),auxs(nn*gl)
integer :: funit=200
integer :: iostatus
character(255) :: line, linehead, linedata
integer :: posco, poseq
integer :: nvin, npxe

open(unit=funit,file='DATVIN',status='OLD',action='READ')

do
  read(funit,'(A)',iostat=iostatus) line
  if (iostatus /= 0) then
    exit
  endif
  line=trim(adjustl(line))
  
  if (line(1:1)=='#') then
    cycle
  endif
    
    poseq = index(line,'=')
    posco = index(line,'#')
    
    if ( (poseq == 0).and.(posco == 0)  )then ! esto es, si tengo un encabezado.
      linehead = trim(adjustl(line))  
      else if ( ( poseq /= 0).and.( posco /=0 ) ) then  ! esto es, si tengo la 
    ! definicion de etiqueta con
    ! commentario.
    linehead = trim(adjustl(line(:poseq-1) ) )
    linedata = trim(adjustl(line(poseq+1:posco-1)))
      else if ( poseq /= 0) then      ! esto es, etuiqueta sin comentario.
    linehead = trim(adjustl(line(1:poseq-1)))
    linedata = trim(adjustl(line(poseq+1:)))
      else if ( posco /= 0 )  then ! esto es, comentario en la línea.
        
    linehead = trim(adjustl(line(:posco-1)))
    linedata = ''
      else   ! en cualquier otro caso agarro toda la linea, pero tampoco hay igual.
      ! esto no tendría que ocirrir nunca!
    linehead = trim(adjustl(line))
    linedata =  ''
    end if
    select case (linehead)
    
    case ('NPXE')
      read(linedata,*), npxe
    case('NVIN')
    ! numero de vinculos
      read(linedata,*), nvin
    case('Vinculos')
      allocate(MVIN(NVIN,2))
      allocate(UVIN(NVIN))
      allocate(XVIN(NVIN,3))
      poseq = 0
!      en el sigiente do obtengo MVIN, XVIN,UVIN
      do while ( poseq < nvin )
  
         read(funit,'(A)'), linedata
         linedata=trim(adjustl(linedata))
         if (linedata(1:1)=='#') then
           cycle
         else
           poseq=poseq+1
         end if
         posco=index(linedata,' ')
         read(linedata,*),MVIN(poseq,1),XVIN(poseq,:),MVIN(poseq,2),UVIN(poseq)

      end do
!      do poseq=1,nvin
!        print*,MVIN(poseq,1),XVIN(poseq,:),UVIN(poseq)
!      enddo
    end select

enddo  

close(200)


end subroutine leervinc
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! la próxima subrutina interpreta la matrix de vinculos.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine  hacerrs(gl,nn,nnxe,nvin,MVIN,XVIN,UVIN,Us,Fr)
implicit none

integer, intent(in) :: gl, nn, nnxe, nvin
integer, intent(in) :: MVIN(nvin,1)

end subroutine  hacerrs

end module mefbase
