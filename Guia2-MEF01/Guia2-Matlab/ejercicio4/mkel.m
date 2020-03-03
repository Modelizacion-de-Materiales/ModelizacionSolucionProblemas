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
L=norm(r2-r1);
find=fopen(fname,'a');
fprintf(find,'\n \n Elemento %d \n', elemento );
fclose(find);

if L~=0
    theta=atan2(r2(2)-r1(2),r2(1)-r1(1));
    R=[ cos(theta)  sin(theta) ; -sin(theta)  cos(theta) ]; 
    kloc=[ 12 6*L  -12 6*L ; 6*L  4*L^2  -6*L 2*L^2 ; ...
       -12  -6*L  12  -6*L ; 6*L  2*L^2  -6*L  4*L^2 ];
   kloc=( modulo*seccion/L^3)*kloc;   
elseif L==0
    kloc=modulo*[ 1 0 1 0 ; 0 0 0 0 ; 1 0 1 0 ; 0 0 0 0 ];
end

dlmwrite(fname,kloc,'-append','delimiter','\t','precision','%6.4e');