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

fkey=fopen(['F',vinfile],'w');
for i=1:nelem
    a=Nodos(i,1);
    b=Nodos(i+1,1);
    L=b-a;
    F(i)=F(i)+quadgk(@(x) df1(x,L,a),a,b);
    F(i+1)=quadgk(@(x) df2(x,L,a),a,b);
    fprintf(fkey,'F nodo %d  %6.4f \n',i,F(i));
end
fprintf(fkey,'F nodo %d  %6.4f \n',nnod,F(nnod));
fclose(fkey);

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
fprintf(fid,'Nodos \n #nodo X Y  vins  Ux Uy Fx Fy \n');
%solo el último nodo tiene vínculo, el resto estan todos cargados en x y
%vinculados en y
for i=1:nnod-1
    fprintf(fid,'%d  %6.4f  0.0  %d  1  0.0  0.0  %6.4f  0.0 \n',...
        i, Nodos(i,1), -1, F(i));
end
% y me queda el último nod que es distinto, está vinculado!
fprintf(fid,' %d  %6.4f  0.0  1  1  0.0  0.0  0.0  0.0 \n',nnod, Nodos(nnod,1) );
fprintf(fid,'# F(nnod) =  %6.4f \n',F(nnod));
fprintf(fid,'Fin Nodos \n');




   