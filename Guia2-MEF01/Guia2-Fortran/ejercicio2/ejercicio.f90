program ejercicio
use mefbase
implicit none

integer :: NN, GL, NNXE, NE
integer,allocatable :: MC(:,:),MVIN(:,:)
double precision, allocatable :: MN(:,:),MP(:,:),U(:),F(:)
double precision :: Uvin(:),Fvin(:)
integer,allocatable :: r(:) , s(:)

integer :: I,J

call leermimsh(GL,NN,NNXE,NE,MN,MC,MP)

do I=1,NE
  print*,MC(I,:), MP(I,:)
enddo


end program ejercicio
