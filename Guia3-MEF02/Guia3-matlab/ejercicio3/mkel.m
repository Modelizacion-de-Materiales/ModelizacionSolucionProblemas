function kloc=mkel(nodlocal,gl,varargin)
modulo=varargin{1};
seccion=1;
L=1;
if nargin>=5;
    seccion=varargin{2};
end
elemento=varargin{end-1};
fname=varargin{end};

r1=nodlocal(1,:);
r2=nodlocal(2,:);
theta=atan2(r2(2)-r1(2),r2(1)-r1(1));
L=norm(r2-r1);
R=[ cos(theta)  sin(theta) ; -sin(theta)  cos(theta) ]; 
find=fopen(fname,'a');
fprintf(find,'\n \n Elemento %d \n', elemento );
fclose(find);


if (gl==2)
    kloc=(modulo*seccion/L)*[1  0 -1 0 ; 0 0 0 0 ; -1 0 1 0; 0 0 0 0];
    T=[R , zeros(2) ; zeros(2), R];
    kloc=T'*kloc*T;
elseif (gl==1)
    kloc=(modulo*seccion/L)*[1 -1; -1  1] ;
end

dlmwrite(fname,kloc,'-append','delimiter','\t','precision','%6.4e');




