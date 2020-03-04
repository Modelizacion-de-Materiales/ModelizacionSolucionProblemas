% # Copyright Mariano Forti
% fid=writemsh(NOD,MC,fileout)
% escribe el mesh dado por la lista de coordenadas de nodos, NOD, y la matriz
% de conectividad MC, en el archivo fileout, que debe ser de extensión .msh.

function fid=writemsh(NOD,MC,fileout)

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
%Determine element type from nodes per element.
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

% Displacements
% nodedatablock(fid,nnodes,'"Displacement (m)" ',3,[Ux,Uy,zeros(nnodes,1)]);
% % Forces
% nodedatablock(fid,nnodes,'"Forces (N)" ',3,[Fx',Fy',zeros(nnodes,1)]);
% nodedatablock(fid,nnodes,'"sigma x (Pa,av) " ',1,sigma_nod(:,1));
% nodedatablock(fid,nnodes,'"sigma y (Pa,av) " ',1,sigma_nod(:,2));
% nodedatablock(fid,nnodes,'"shear (Pa,av) " ',1,sigma_nod(:,3));
% %tensiones
% elementdatablock(fid,nels,' "sigma x (Pa)" ',1,sigma(:,1));
% elementdatablock(fid,nels,' "sigma y (Pa)" ',1,sigma(:,2));
% elementdatablock(fid,nels,' "shear (Pa)" ',1,sigma(:,3));


    function nodedatablock(fkey,nn,dataname,datadim,datain)
        nodedatahead=['$NodeData \n 1 \n', dataname,' \n'];
        fprintf(fkey,nodedatahead);
        %time tags
        fprintf(fkey, '1 \n  0.0 \n');
        %integer tags, time step, dim, nnodes, num_partition
        fprintf(fkey, '3 \n 0 \n %d \n %d \n',datadim,nn);
        for ii=1:nn
            thisline=num2str(ii, '%d  ');
            for ji=1:datadim; thisline=[thisline,' ',num2str(datain(ii,ji),'%6.4e')]; end
            fprintf(fkey,[thisline,'\n']);
        end
        fprintf(fkey,'$EndNodeData\n');
    end


    function elementdatablock(fkey,ne,dataname,datadim,datain)
        elementdatahead=['$ElementData \n 1 \n', dataname,' \n'];
        fprintf(fkey,elementdatahead);
        %time tags
        fprintf(fkey, '1 \n  0.0 \n');
        %integer tags, time step, dim, nnodes, num_partition
        fprintf(fkey, '3 \n 0 \n %d \n %d \n',datadim,ne);
                for ii=1:ne
                    thisline=num2str(ii, '%d  ');
                    for ji=1:datadim; thisline=[thisline,' ',num2str(datain(ii,ji),'%6.4e')]; end
                    fprintf(fkey,[thisline,'\n']);
                end
        fprintf(fkey,'$EndElementData\n');
    end

end


