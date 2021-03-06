function F=mkvin(Nodos,vinfile,varargin)
%%
nnod=size(Nodos,1);
nelem=nnod-1;
F=zeros(nnod,1);

A=varargin{1}; E=varargin{2}; C=varargin{3};

%Tx=@(x) C*x; % N/m
%N1=@(x,L,a) (1-(x-a)./L).*feval(Tx,x);
%N2=@(x,L,a) ((x-a)./L).*feval(Tx,x);

df1=@(x,L,a) feval(@N1,x-a,L).*feval(@Tx,x,C);
df2=@(x,L,a) feval(@N2,x-a,L).*feval(@Tx,x,C);
df3=@(x,L,a) feval(@N3,x-a,L).*feval(@Tx,x,C);
df4=@(x,L,a) feval(@N4,x-a,L).*feval(@Tx,x,C);
gl=2;

for i=1:nelem
    a=Nodos(i,1);
    b=Nodos(i+1,1);
    L=b-a;
%     f1=quadgk(@(x) df1(x,L,a),a,b);
     f1=quad(@(x) df1(x,L,a),a,b);
%     f2=quadgk(@(x) df2(x,L,a),a,b);
    f2=quad(@(x) df2(x,L,a),a,b);
%     f3=quadgk(@(x) df3(x,L,a),a,b);
    f3=quad(@(x) df3(x,L,a),a,b);
%     f4=quadgk(@(x) df4(x,L,a),a,b);
    f4=quad(@(x) df4(x,L,a),a,b);
    F((i-1)*gl+1)=F((i-1)*gl+1)+f1;
    F((i-1)*gl+2)=F((i-1)*gl+2)+f2;
    F((i-1)*gl+3)=f3;
    F((i-1)*gl+4)=f4;
end

fid=fopen(vinfile,'w');
fprintf(fid,'%d Nodos \n',nnod);
fprintf(fid,'%d Elementos \n',nelem);
fprintf(fid,'%d Nodos por elemento \n',2);
fprintf(fid,'%d grados de libertad por nodo \n',2);
fprintf(fid,'Elementos \n #Elemento n1 n2 A(m^2)  E (Pa) \n');
for i=1:nelem
    % Elemento n1 n2 A(m^2)  E (Pa)
    fprintf(fid,' %d  %d  %d  %6.4e  %6.4e  \n',i,i,i+1,A,E);
end
fprintf(fid,'Fin Elementos \n');
fprintf(fid,'Nodos \n #nodo X Y  vins  Ux  Fx \n');
%solo el primero y último nodo tienen vínculo, el resto estan todos cargados.

fprintf(fid,'%d  %6.4f  0.0  %d  %d  %6.4f  %6.4f %6.4f  %6.4f \n',...
        1, Nodos(1,1), 1, 2, 0.0,  0.0, F(1), F(2) ) ;
for i=2:nnod-1
    fprintf(fid,'%d  %6.4f  0.0  %d  %d  %6.4f  %6.4f %6.4f  %6.4f \n',...
        i, Nodos(i,1), -1, -2, 0.0,  0.0, F(gl*(i-1)+1 ), F( i*gl ) ) ;
end
fprintf(fid,'%d  %6.4f  0.0  %d  %d  %6.4f  %6.4f %6.4f  %6.4f \n',...
        nnod, Nodos(nnod,1), 1, -2, 0.0,  0.0, F(gl*(nnod-1)+1 ) , F(gl*nnod) ) ;
fprintf(fid,'Fin Nodos \n');




   