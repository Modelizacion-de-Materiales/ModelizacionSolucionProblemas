program main
use globals
implicit none
double precision, allocatable::Kred(:,:),U(:),F(:),baux(:),Ulocal(:,:),Flocal(:,:), Fparal(:), tension(:)
integer:: i,j,n1,n2
character(20)::source
integer::info
integer,allocatable::ipiv(:)
character(20)::nvinculos

source="archivo.dat"
! Obtengo los vínculos y las dimensiones
call getdata(source)
allocate(Kred(nunk,nunk),U(nnodo*gl),F(nnodo*gl),baux(nunk))
allocate(ipiv(nnodo*gl))
allocate(Ulocal(nelem,2*gl), Flocal(nelem,2*gl),Fparal(nelem),tension(nelem))

Kred=0.d0
U=0.d0
F=0.d0
Ulocal=0.d0
Flocal=0.d0
Fparal=0.d0
info=0
ipiv=0

call mklocalK()

open(1,file="vermats.dat")
write(1,*), " ## Matrices Locales "
do i=1,nelem
	write(1,'(/,A,i4)'), "#Elemento ", i
	do j=1,2*gl
		write(1,'(4EN12.3)'), localK(i,j,:)
	end do
end do

! Y ahora armo la matriz
K=0.d0
call extendmat()

write(1,'(/,/,A)'), "Matriz del sistema"
do i=1,nnodo*gl
	write(1,'(2EN12.3,5X,2EN12.3,5X,2EN12.3,5X,2EN12.3)'), K(i,:)
	if (mod(i,2)==0) write(1,*)
end do


close(1)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Resuelvo el sistema
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
U(vvin)=Uvin
F(vunk)=Fvin
Kred=K(vunk,vunk)
baux=Fvin-matmul(K(vunk,vvin),U(vvin))
print*,
print*, "baux"
print '(EN15.3)', baux

print*, "Sistema a resolver"
write(nvinculos,'(I4)'),nunk
print '('//trim(nvinculos)//'I15)' , vunk

call dgesv(nunk,1,Kred,nunk,ipiv,baux,nunk,info)
U(vunk)=baux

F(vvin)=matmul(K(vvin,:),U)
F(vunk)=Fvin

do i=1,nunk
print '(I1,A2,'//trim(nvinculos)//'EN15.3,A3,EN15.3,A3,EN15.3,A1)',&
      &vunk(i),' |', K(vunk(i),vunk),'| |',U(vunk(i)),'|=|',Fvin(i), '|'
end do

print*,
print*, "       U                F"
do i=1,gl*nnodo
print '(2i4, 2EN15.3)',(i+1)/gl,mod(i+1,gl)+1,  U(i),F(i)
end do


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Imprimo los resultados
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
open(2,file="resultados.dat")
write(2,*),"# X  Y  dx  dy  Fx  Fy  "

do i=1,nnodo
		write(2,'(6EN15.3)'), X(i),Y(i),U(gl*(i-1)+1),U(gl*(i-1)+2), &
                                      & F(gl*(i-1)+1),F(gl*(i-1)+2)
end do

write(2,'(/,/,A)') "# nodo  Xinicial Yinicial Xfinal Yfinal"
do i=1,nelem
	n1=elementos(i,1) 
	n2=elementos(i,2)
	write(2,'(I3,4EN14.3)'),n1, X(n1), Y(n1), X(n1)+U(gl*(n1-1)+1), Y(n1) + U(gl*(n1-1)+2)
	write(2,'(I3,4EN14.3)'),n2, X(n2), Y(n2), X(n2)+U(gl*(n2-1)+1), Y(n2) + U(gl*(n2-1)+2)
	write(2, * ) , ''
end do

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!F
! Ahora quiero ver las fuerzas locales
! Para saber las tensiones
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

print '(/,A)' , 'Fuerzas locales'
do i=1,nelem
n1=elementos(i,1)
n2=elementos(i,2)
Ulocal(i,1:gl)=U(gl*(n1-1)+1:gl*n1)
Ulocal(i,gl+1:2*gl)=U(gl*(n2-1)+1:gl*n2)
Flocal(i,:)=matmul(localK(i,:,:),Ulocal(i,:))
!Flocal(i,2,:)=matmul(localK(i,gl+1:2*gl,:),U(gl*(n2-1):gl*n2))
do j=1,gl
Fparal(i)=Fparal(i)+Flocal(i,j)**2
end do
Fparal(i)=sqrt(Fparal(i))
tension(i)=Fparal(i)/seccion(i)
print '(/,A,i4,2EN12.3)', 'Elemento' , i, Fparal(i), tension(i)
print '(i4,100EN15.3)', n1, Flocal(i,1:gl)
print '(i4,100EN15.3)', n2, Flocal(i,gl+1:2*gl)
end do

end program
