function F=mkvin(Nodos,vinfile,varargin)
%%
nnod=size(Nodos,1);
nelem=nnod-1;
F=zeros(nnod,1);

A=varargin{1}; E=varargin{2}; k=varargin{3};

long=Nodos(end,1)-Nodos(1,1);

tol_centro=long/nnod;
% for i=1:nelem
%     a=Nodos(i,1);
%     b=Nodos(i+1,1);
%     L=b-a;
% end

fid=fopen(vinfile,'w');
fprintf(fid,'%d Nodos \n',nnod+1);
fprintf(fid,'%d Elementos \n',nelem+1);
fprintf(fid,'%d Nodos por elemento \n',2);
fprintf(fid,'%d grados de libertad por nodo \n',2);
fprintf(fid,'Elementos \n #Elemento n1 n2 A(m^2)  E (Pa) \n');
for i=1:nelem
    % Elemento n1 n2 A(m^2)  E (Pa)
    fprintf(fid,' %d  %d  %d  %6.4e  %6.4e  \n',i,i,i+1,A,E);
end
% me falta incluir el elemento que se constituye por el resorte, 
% le pongo momento de inercia nulo!
fprintf(fid,' %d  %d  %d  %6.4e  %6.4e  \n',nelem+1,nnod,nnod+1,0.0,k);

fprintf(fid,'Fin Elementos \n');
fprintf(fid,'Nodos \n #nodo X Y  vins  Uy  Q  Fy  M \n');
%solo el último nodo tiene vínculo, el resto estan todos cargados.

%primer nodo: empotrado.
fprintf(fid,'%d  %6.4f  0.0  %d  %d  %6.4f  %6.4f  %6.4f  %6.4f \n',...
            1, Nodos(1,1), 1, 2 , 0.0,  0.0,  0.0, 0.0 );
% Nodos de adentro: en equilibrio, salvo el del meido que esta apoyado.

for i=2:nnod-1
    if abs( Nodos(i) - long/2 ) > tol_centro
        fprintf(fid,'%d  %6.4f  0.0  %d  %d  %6.4f  %6.4f  %6.4f  %6.4f \n',...
            i, Nodos(i,1), -1, -2 , 0.0,  0.0,  0.0, 0.0 );
        continue;
    else
        fprintf(fid,'%d  %6.4f  0.0  %d  %d  %6.4f  %6.4f  %6.4f  %6.4f \n',...
            i, Nodos(i,1), 1, -2 , 0.0, 0.0 , 0.0, 0.0 ) ;
    end
end
% último nodo, en equilibrio con la fuerza
fprintf(fid,'%d  %6.4f  0.0  %d  %d  %6.4f  %6.4f  %6.4f  %6.4f \n',...
            nnod, Nodos(nnod,1), -1, -2 , 0.0,  0.0, -50e3, 0.0 );
%y pongo un nodo extra que simula el agarre del resorte
fprintf(fid,'%d  %6.4f  0.0  %d  %d  %6.4f  %6.4f  %6.4f  %6.4f \n',...
            nnod+1, Nodos(nnod,1), 1, 2 , 0.0,  0.0,  0.0, 0.0 );
fprintf(fid,'Fin Nodos \n');




   