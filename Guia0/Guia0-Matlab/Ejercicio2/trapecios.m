function [I,esfuerzo] = trapecios(a,b,dx,fun)
%%% 

No=(b-a)/dx;
N=round(No);

xi=a;
I=0;
S=0;
% for i=1:N
%     xo=xi;
%     xi=xo+dx;
%     Ii=(fun(xo)+fun(xi))*dx/2.;
%     I=I+Ii;
% end
esfuerzo = 0;
for i=2:N-1
    xo=xi;
    xi=xo+dx;
    S=S+fun(xi);
    esfuerzo = esfuerzo + 1;
end

I=((b-a)/(2*N))*( fun(a) + 2*S + fun(b) );