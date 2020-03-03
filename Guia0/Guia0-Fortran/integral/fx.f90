function f(x)
implicit none
real(8)::x,f

f=200*(x/(5.+x))*exp(-2.*x/300.)

end function
