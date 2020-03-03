!Subrutina de iniciación de vectores. Mariano Forti
!---------------------------------------------------------------
subroutine getVecs(archivo,N,nx,nvin,i,j,X,Dvin,Qvin)
implicit none

 character(8)::archivo			 	!-----variables de i/o
integer::nx,nvin,N
integer::i(nx),j(nvin)
real(8)::X(N),Dvin(nvin),Qvin(nx)

integer::v,s,t,coordenada,fuerza,nodo		!----variables locales
integer::cvin,jk
integer::eof
real(8)::xi,Djk,Qjk

open(2,file=archivo)
v=1
s=1
t=1
xi=0.
X=0.
eof=0
nodo=0
coordenada=1
fuerza=2
print*, "leer vinculos de"
print*, archivo
read(2,*,iostat=eof), X(1),cvin,jk,Djk,Qjk

do 
	if(cvin==coordenada) then
		j(s)=2*(v-1)+jk
		Dvin(s)=Djk
		if(s<nvin) s=s+1
	else if(cvin==fuerza) then
		i(t)=2*(v-1)+jk
		Qvin(t)=Qjk
		if(t<nx) t=t+1
	else if(cvin==nodo) then
		i(t)=2*v-1
		i(t+1)=2*v
		Qvin(t)=0.
		Qvin(t+1)=0.
		t=t+2
	end if
	read(2,*,iostat=eof), xi,cvin,jk,Djk,Qjk
	if(eof/=0) exit
	print*, xi,cvin,jk,Djk,Qjk
!	print*,eof
	if(xi/=X(v)) then
		if(v<N) v=v+1
		X(v)=xi
	end if
	print*,X(v), v
end do
print*,"----------------"


end subroutine
