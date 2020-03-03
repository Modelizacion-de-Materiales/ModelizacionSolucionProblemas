!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Aca empieza una subrutina para leer el archivo de entrada
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine getdata(source)
use globals

implicit none


integer::unitunique
character(20)::source
character(6)::linea
integer::nunit,i,j,n
double precision, allocatable::Uaux(:),Faux(:)
double precision:: U(2),F(2)
integer, allocatable:: vins(:),vinaux(:),unkaux(:)

nunit=unitunique(source)

open(nunit,file=source,status='old')

! Leo el encabezado del archivo.

read(nunit,*) nelem
read(nunit,*) nnodo
read(nunit,*) gl

! Allocatar vectores
allocate(X(nnodo),Y(nnodo))
allocate(Uaux(nnodo*gl),Faux(nnodo*gl))
allocate(vins(gl), vinaux(nnodo*gl),unkaux(nnodo*gl) )
allocate(modelast(nelem),seccion(nelem),elementos(nelem,2),L(nelem))
!Allocatar Matrices
allocate( localK(nelem,gl*2,gl*2), K(gl*nnodo,gl*nnodo) )

Uaux=0.d0
Faux=0.d0
vins=0
vinaux=0
unkaux=0
modelast=210.d0

 ! Me salto dos línea despues de leer el encabezado
read(nunit,*); read(nunit,*) 
! Inicializo la dimensinoes 
nvin=0
nunk=0

 ! Ahora leo la info de los elementos
do i=1,nelem
	read(nunit,*), n, elementos(n,:), seccion(n), modelast(n)
end do

 ! Me salto dos línea despues de leer el encabezado
read(nunit,*); read(nunit,*) ; read(nunit,*) 

 ! Ahora leo la info de los nodos
do i=1,nnodo
	read(nunit,*), n, X(n), Y(n), vins, U, F
	do j=1,gl
		if (vins(j)>0) then
			print*, "vinculo en nodo", n, "direccion", j, ",",U(j)
			nvin=nvin+1
			vinaux(nvin)=vins(j)+(n-1)*gl
			Uaux(nvin)=U(j)
		else if (vins(j)<0) then
			print*, "fuerza en nodo", n, "direccion", j,",",F(j)
			nunk=nunk+1
			unkaux(nunk)=-vins(j)+(n-1)*gl
			Faux(nunk)=F(j)
		end if
	end do
end do

allocate(vvin(nvin),vunk(nunk))
allocate(Uvin(nvin),Fvin(nunk))
vvin=vinaux(1:nvin)
vunk=unkaux(1:nunk)
Uvin=Uaux(1:nvin)
Fvin=Faux(1:nunk)

close(nunit)


end subroutine


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Ahora me hago la subrutina de armar la matriz
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine mklocalK()
use globals
implicit none
integer::i,j
double precision::R(gl*2,gl*2)
R=0.d0

localk=0.d0
do i=1,nelem
	localK(i,1,1)=1.d0
	localK(i,1,3)=-1.d0
	localK(i,3,1)=-1.d0
	localK(i,3,3)=1.d0
	L(i)=sqrt( ( X(elementos(i,1))-X(elementos(i,2)) )**2 + ( Y(elementos(i,1))-Y(elementos(i,2)) )**2 )
	localK(i,:,:)=((seccion(i)*modelast(i))/L(i))*localK(i,:,:)
	call mkrotamat(X(elementos(i,:)),Y(elementos(i,:)),localK(i,:,:))
end do

end subroutine

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Ahora armo la subrutina que rota las matrices locales
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine mkrotamat(Xr,Yr,rotaK)
use globals

implicit none
integer::i
double precision:: Xr(2),Yr(2)
double precision:: rotaK(2*gl,2*gl)
double precision:: theta,s,c
double precision:: R(2*gl,2*gl),RT(2*gl,2*gl)

theta=atan( (Yr(2)-Yr(1) )/( Xr(2)-Xr(1) ) )
s=dsin(theta)
c=dcos(theta)

R=0.d0
R(1,1)=c
R(1,2)=s
!R(1,3)=-c**2
!R(1,4)=-c*s
R(2,1)=-s 
R(2,2)=c
!R(2,3)=-c*s
!R(2,4)=-s**2
!R([3,4],[1,2])=-R([1,2],[1,2])
R([3,4],[3,4])=R([1,2],[1,2])

do i=1,2*gl
	RT(i,:)=R(:,i)
end do

rotaK=matmul(RT,matmul(rotaK,R))

end subroutine


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Subrutina para extender las matrices
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

subroutine extendmat()
use globals

implicit none

integer::i,j,p,q
integer::n1,n2,n

do n=1,nelem
	do i=1,gl ; do j=1,gl
	do p=1,2 ; do q=1,2
n1=elementos(n,p)
n2=elementos(n,q)

K( gl*(n1-1)+i,gl*(n2-1)+j) = K( gl*(n1-1)+i,gl*(n2-1)+j) + localK(n, (p-1)*gl + i , (q-1)*gl + j )

	end do ; end do
	end do ; end do
end do

end subroutine
