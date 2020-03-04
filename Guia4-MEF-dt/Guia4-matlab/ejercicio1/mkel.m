function kloc=mkel(casename,type,nodlocal,el,gl,modulo)

%   kloc=mkel(type,nodlocal,gl,varargin)
% Esta función genera las matrices elementales para distintos tipos de
% elementos. 
%  type: tipo de elemento
%   type=1:  resortes 2d ,     Kel = [ k 0 -k 0 
%                                      0 0  0 0 ; 
%                                     -k 0  k 0 ;
%                                      0 0  0 0 ]
%            en este caso modulo puede ser dado con un componente para cada
%            elemento. 
%
%   type=2:  barras a tracción,      Kel= A*E/L [ 1  0  -1  0;
%                                                 0  0   0  0;
%                                                -1  0   1  0;
%                                                 0  0   0  0 ];
%            en este caso modulo puede ser dado como [A E] para cada
%            elemento.
%  
%   type=3:  barra con flección,     Kel= E*I/L^3 [ 12 6L   -12   6L ;
%                                                   6L 4L^2 -6L  2L^2;
%                                                  -12 -6L   12   -6L; 
%                                                   6L 2L^2 -6L  4L^2] 
%            en este caso modulo puede ser [E,I] para cada elemento. 
filename=['matrices',casename,'.dat'];
if el == 1
    fid=fopen(filename,'w');
    fprintf(fid,'Matrices Elementales\n===================\n\n');
else
    fid=fopen(filename,'a');
end

if (type==2)
    r1=nodlocal(1,:);
    r2=nodlocal(2,:);
    theta=atan2(r2(2)-r1(2),r2(1)-r1(1));
    L=norm(r2-r1);
    R=[ cos(theta)  sin(theta) ; -sin(theta)  cos(theta) ];
    T=[R , zeros(2) ; zeros(2), R];
    E=modulo(1);A=modulo(2);
    kloc=(E*A/L)*[1  0 -1 0 ; 0 0 0 0 ; -1 0 1 0; 0 0 0 0];
    kloc=T'*kloc*T;
    fmt='%6.8e  %6.8e  %6.8e  %6.8e \n';
elseif (type==1)
    kloc=modulo*[1 -1; -1  1] ;
    fmt='%6.8e %6.8e \n';
elseif (type==3)
    r1=nodlocal(1,:);
    r2=nodlocal(2,:);
    theta=atan2(r2(2)-r1(2),r2(1)-r1(1));
    L=norm(r2-r1);
    E=modulo(1);I=modulo(2);
    kloc=(E*I/L^3)*[12 6*L -12 6*L;6*L 4*L^2 -6*L  2*L^2;...
                  -12 -6*L 12 -6*L;  6*L 2*L^2 -6*L  4*L^2] ;
    fmt='%6.8e  %6.8e  %6.8e  %6.8e \n';
end

fprintf(fid,'\n Elemento %d \n', el);
for i=1:size(kloc,1)
    fprintf(fid,'%6.8e  %6.8e  %6.8e  %6.8e \n',kloc(i,:) );
end
fclose(fid);

