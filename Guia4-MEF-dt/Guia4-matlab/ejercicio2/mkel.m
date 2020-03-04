function kloc=mkel(nodlocal,gl,varargin)
modulo=varargin{1};
seccion=varargin{2};
nelem=varargin{3};
r1=nodlocal(1,:);
r2=nodlocal(2,:);
theta=atan2(r2(2)-r1(2),r2(1)-r1(1));
L=norm(r2-r1);
R=[ cos(theta)  sin(theta) ; -sin(theta)  cos(theta) ];
if (gl==2)
    T=[R , zeros(2) ; zeros(2), R];
    kloc=(modulo*seccion/L)*[1  0 -1 0 ; 0 0 0 0 ; -1 0 1 0; 0 0 0 0];
    kloc=T'*kloc*T;
    fid=fopen('matrices.dat','a');
    fprintf(fid,'\n Elemento %d \n', nelem);
    for i=1:gl*2
        fprintf(fid,'%6.8e  %6.8e  %6.8e  %6.8e \n',kloc(i,:) );
    end
    fclose(fid);
elseif (gl==1)
    kloc=modulo*seccion*[1 -1; -1  1]/L ;
end


