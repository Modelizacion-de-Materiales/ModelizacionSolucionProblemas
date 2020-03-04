% function fid=writemsh(NOD,MC,fileout)
% Funcion que escribe un archivo .msh con el mallado dado.
% NOD :  matriz de nodos con las coordenadas xyz de cada uno de los nodos de tipo triángulo.
% MC  : Matriz de conectividad.
% fileout: Archivo donde guardar.

function fid=writemsh(NOD,MC,fileout)

%abro el archivo.
fid=fopen(fileout,'w');

% File Heading
fprintf(fid,'$MeshFormat\n');
fprintf(fid,'2.2 0 8\n');
fprintf(fid,'$EndMeshFormat\n');


%Nodes
[nnodes dim]=size(NOD);
if dim<3
    NOD=[NOD zeros(nnodes,3-dim) ]; %NOD can be an X only or XY map, but for the msh
                                  % I need X Y Z.
end
fprintf(fid,'$Nodes\n');
fprintf(fid,'%d\n',nnodes);
for i=1:nnodes
    fprintf(fid,'%d  %6.4f  %6.4f  %6.4f\n',i, NOD(i,:));
end
fprintf(fid,'$EndNodes\n');

%Elements
[nels nnxel]=size(MC);
%Determine element type
if nnxel==1
    elty=15; %points
    mcstr=' %d ';
elseif nnxel==2
    elty=1; % lines
    mcstr='  %d  %d  ';
elseif nnxel==3;
    elty=2;
    mcstr=' %d  %d  %d ';
end
ntags=0;

fprintf(fid,'$Elements\n');
fprintf(fid,'%d\n',nels);
for i=1:nels
    %            i  elty   ntags  tags      MC              
    fprintf(fid,['%d   %d     %d      ',mcstr, '\n'],...
        i, elty, ntags,MC(i,:) );
end
fprintf(fid,'$EndElements\n');
fclose(fid);