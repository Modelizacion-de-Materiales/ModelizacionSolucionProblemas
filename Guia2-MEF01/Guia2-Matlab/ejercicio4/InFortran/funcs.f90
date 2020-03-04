! Funciones de interpolación, mariano Forti
!-----------------------------------------------
function N1(x,L)
implicit none
real(8)::N1,x,L
N1=(1/L**3)*(2.*x**3-3*x**2*L+L**3)
end function N1

function N2(x,L)
implicit none
real(8)::N2,x,L
N2=(1/L**3)*(L*x**3-2.*x**2*L**2+x*L**3)
end function N2

function N3(x,L)
implicit none
real(8)::N3,x,L
N3=(1/L**3)*(-2.*x**3+3*x**2*L)
end function N3

function N4(x,L)
implicit none
real(8)::N4,x,L
N4=(1/L**3)*(x**3*L-x**2*L**2)
end function N4
