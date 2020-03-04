% #Copyright Mariano Forti
% Esta función escribe un bloque de datos de nodos para ser 
% agregados a un archivo msh con los nodos y elementos ya terminados.
%
% fname = nombre del archivo .msh donde se guardara. (string)
% nn = numero de nodos (entero)
% dataname = etiqueta que identifica a los datos (string, comillas dobles)
% datadim = dimensión de los datos (entero, 1: escalar, 3: vectores, 9: tensores)
% datain= datos a escribir (real, nn x dadadim)
% time = tiempo actual (real)
% timestep = indice de tiempo (entero)

function nodedatablock(fname,nn,dataname,datadim,timestep,time,datain)
fkey=fopen(fname,'a');
nodedatahead=['$NodeData \n 1 \n', dataname,' \n'];
fprintf(fkey,nodedatahead);
%time tags
fprintf(fkey, '1 \n  %6.4e \n',time);
%integer tags, time step, dim, nnodes, num_partition
fprintf(fkey, '3 \n %d \n %d \n %d \n',timestep,datadim,nn);
for ii=1:nn
    thisline=num2str(ii, '%d  ');
    for ji=1:datadim; thisline=[thisline,' ',num2str(datain(ii,ji),'%6.4e')]; end
    fprintf(fkey,[thisline,'\n']);
end
fprintf(fkey,'$EndNodeData\n');
fclose(fkey);
end
