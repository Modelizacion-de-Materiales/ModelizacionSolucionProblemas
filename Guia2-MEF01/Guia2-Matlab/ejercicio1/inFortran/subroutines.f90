subroutine matrizlocal(L,k,g,A)
implicit none

integer:: g
double precision:: L,k
double precision:: A(2*g,2*g)

integer:: i

A(1,1)=1.d0
A(1,2)=-1.d0
A(2,1)=-1.d0
A(2,2)=1.d0

A=k*A

end subroutine




subroutine extendmat(g,Nnodo,R,K)
implicit none

! Inputs and outputs.
integer:: g, Nnodo
double precision:: R(g*2,g*2), K(g*Nnodo,g*Nnodo)
!Internals:
integer:: u,v,w


print*, "Calculando la matriz"
do u=1,Nnodo-1
	do v=1,2*g
		do w=1,2*g
		K(g*(u-1)+v,g*(u-1)+w)=K(g*(u-1)+v,g*(u-1)+w)+R(v,w)
		end do
	end do
end do


end subroutine
