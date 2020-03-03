function [I,esfuerzo]=simpson(a,b,dx,fun)

Spar=0 ;
Simp=0;
No=(b-a)/dx;
N=round(No);

I=0;
xi=a-dx;
esfuerzo = 0;

for i=2:2:N-1
    xi=xi+2*dx;
    Spar=Spar+fun(xi);
    esfuerzo = esfuerzo+1;
end

xi=a;
for i=3:2:N
    xi=xi+2*dx;
    Simp=Simp+fun(xi);
    esfuerzo=esfuerzo+1;
end

I=((b-a)/(3*N))*( fun(a) + 4*Simp + 2*Spar + fun(b) );