module dataread
implicit none

contains 

subroutine getdata(LX,DX,DT,TMAX,T0,KX,LM,method,tolerance)

implicit none
double precision             :: LX,DX,KX,LM,DT,TMAX,TOLERANCE
integer   :: method
double precision             :: T0(3)
character(6)     :: filein='DATIN'
character(512)     :: line
character(512)     :: linehead,linecontent
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
  
  select case (linehead)
    case  ('LX') 
      read(linecontent,*) LX
    case  ('DX')
      read(linecontent,*) DX
    case ('DT')
      read(linecontent,*) DT
    case ('TMAX')
     read (linecontent,*) TMAX
    case ('TO') 
     read(linecontent,*) T0(1), T0(2), T0(3)
    case ('KX') 
     read(linecontent,*) KX
    case ('METHOD')
     read(linecontent,*) METHOD
    case ('TOL')
     read (linecontent,*) TOLERANCE
  end select

enddo


close(50)

LM = KX*DT/(DX**2) ! lambda

end subroutine getdata


end module dataread
