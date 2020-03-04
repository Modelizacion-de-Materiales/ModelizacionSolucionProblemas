function kloc=mkel(nodlocal,gl,varargin)
modulo=varargin{1};
pois=varargin{2};
espe=varargin{3};
nelem=varargin{4};

[nnxel dim]=size(nodlocal);

X=nodlocal(:,1);
Y=nodlocal(:,2);

if dim==2
    Z=zeros(nnxel,1);
elseif dim==3
    Z=nodlocal(:,3);
end

%alfa
ai=X(2)*Y(3)-Y(2)*X(3);
aj=X(1)*Y(3)-Y(1)*X(3);
am=X(1)*Y(2)-Y(1)*X(2);

%beta
bi=Y(2)-Y(3);
bj=Y(3)-Y(1);
bm=Y(1)-Y(2);

%gama
gi=X(3)-X(2);
gj=X(1)-X(3);
gm=X(2)-X(1);

A=0.5*det([ones(3,1) X Y] );

B=[ bi 0 bj 0 bm 0 ; 0 gi 0 gj 0 gm ; gi bi gj bj gm bm ]/(2*A);

% Matriz de elasticidad tensiones planas

D = [ 1 pois 0 ; pois 1 0 ; 0 0 0.5*(1-pois) ]*modulo/(1-pois^2);

%area:
seccion=abs(A);

%matriz local

kloc= espe*seccion*B'*(D*B);

% fid=fopen('matrices.dat','a');
% fprintf(fid,'\n Elemento %d \n', nelem);
% dlmwrite('matrices.dat',kloc*0.91/375000,'-append','delimiter',' ');
%fmt=[];
% for i=1:gl*nnxel; fmt=[fmt,'%6.4f ']; end
%fmt='%6.4f  \n';
%for i=1:gl*nnxel
%    fprintf(fid,fmt,kloc);
%end
% fclose(fid);

matname=['matelem-',num2str(nelem),'.dat'];
save(matname,'kloc','-ascii');
