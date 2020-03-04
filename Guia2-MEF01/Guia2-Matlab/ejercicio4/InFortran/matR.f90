!Subrutina para generar matriz elemental. Mariano Forti
!----------------------------------------------------
subroutine matR(R,dL)
implicit none
real(8)::R(4,4)
real(8)::dL

R(1,1)=12.
R(1,2)=6.*dL
R(1,3)=-12.
R(1,4)=R(1,2)
R(2,1)=R(1,2)
R(2,2)=4.*dL**2
R(2,3)=-R(1,2)
R(2,4)=2.*dL**2
R(3,1)=R(1,3)
R(3,2)=R(2,3)
R(3,3)=R(1,1)
R(3,4)=R(2,3)
R(4,1)=R(1,2)
R(4,2)=R(2,4)
R(4,3)=R(2,3)
R(4,4)=R(2,2)



end subroutine
