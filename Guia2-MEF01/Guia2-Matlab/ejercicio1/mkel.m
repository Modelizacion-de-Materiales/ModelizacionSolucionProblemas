function kloc=mkel(nodlocal,gl,varargin)
modulo=varargin{1};
seccion=1;
L=1;
r1=nodlocal(1,:);
r2=nodlocal(2,:);
theta=atan2(r2(2)-r1(2),r2(1)-r1(1));
if nargin==4;
    seccion=varargin{2};
    L=norm(r2-r1);
end


R=[ cos(theta)  sin(theta) ; -sin(theta)  cos(theta) ]; 



if (gl==2)
    kloc=(modulo*seccion/L)*[1  0 -1 0 ; 0 0 0 0 ; -1 0 1 0; 0 0 0 0];
    T=[R , zeros(2) ; zeros(2), R];
    kloc=T'*kloc*T;
elseif (gl==1)
    kloc=(modulo*seccion/L)*[1 -1; -1  1] ;
end




