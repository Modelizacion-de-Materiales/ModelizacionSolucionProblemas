% function varargout=matmkr(N,lambda,method)
% Esta función hace la matriz para el método de diferencias finitas A
% en una barra de N nodos, dependiendo el method. Si el método es
% explícito, devuelve A / Tl+1 = A*Tl, si es implicito, Tl+1=A\Tl, y en el
% caso Crank-Nicholson, devuelve A y B tales que Tl+1 = A\B*Tl
% method inidca el método y puede ser :
% =1 => explicito
% =2 => implicito
% =3 => C-N
% En todos los casos se consideran condiciones de contorno de temperatura
% fija.

function matris=matmkr(N,lambda,method)
A=zeros(N,N);
A(1,1)=1;
A(N,N)=1;
if method==3
    B=zeros(N,N);
    B(1,1)=1;
    B(N,N)=1;
end

if method==1
    for i=2:N-1;A(i,i-1:i+1)=[lambda,1.-2.*lambda,lambda];end
    matris(1)={A};
elseif method==2
    for i=2:N-1;A(i,i-1:i+1)=[-lambda,1.+2.*lambda,-lambda]; end
    matris(1)={A};
elseif method==3
    for i=2:N-1
        A(i,i-1:i+1)=[-lambda,2*(1.+lambda),-lambda];
        B(i,i-1:i+1)=[lambda,2*(1.-lambda),lambda];
    end
    matris(1)={A};
    matris(2)={B};
end
    

