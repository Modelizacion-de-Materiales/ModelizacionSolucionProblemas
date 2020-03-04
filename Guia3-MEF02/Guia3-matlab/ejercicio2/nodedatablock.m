%function nodedatablock(fname,nn,p,t,dataname,datadim,datain)
%esta funcion escribe los datos de nodo datain, a tiempo t, para el paso p
% fname: nombre del archivo donde se va a guardar (.msh)
% nn: numero de nodos - datos a guardar.
% p : paso temporal a guardar
% t : tiempo a guardar
% dataname: Título de los datos a guardar - string incluyendo las comillas
%           de apertura y cierre
% datadim :  dimensionalidad del dato a guardar
% datain  : dato a guardar

function nodedatablock(fname,nn,p,t,dataname,datadim,datain)
% abrir archivo msh donde agregar los datos actuales.
fkey=fopen(fname,'a');

% encabezado del tipo de datos - datos de nodo
nodedatahead=['$NodeData \n 1 \n', dataname,' \n'];
fprintf(fkey,nodedatahead);

%time tags
fprintf(fkey, '1 \n  %6.4e \n', t);
%integer tags, time step, dim, nnodes, num_partition
fprintf(fkey, '3 \n %d \n %d \n %d \n',p,datadim,nn);

% guardar los datos datain
for ii=1:nn
    thisline=num2str(ii, '%d  ');
    for ji=1:datadim; thisline=[thisline,' ',num2str(datain(ii,ji),'%6.4e')]; end
    fprintf(fkey,[thisline,'\n']);
end
% terminar el bloque de datos.
fprintf(fkey,'$EndNodeData\n');

% cerrar el archivo. 
fclose(fkey);