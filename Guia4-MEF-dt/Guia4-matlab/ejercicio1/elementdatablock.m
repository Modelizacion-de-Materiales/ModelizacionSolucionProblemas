% #Copyright Mariano Forti
% Esta función escribe un bloque de datos de elementos para ser 
% agregados a un archivo msh con los nodos y elementos ya terminados.
%
% fname = nombre del archivo .msh donde se guardara. (string)
% ne = numero de elementos (entero)
% dataname = etiqueta que identifica a los datos (string, comillas dobles)
% datadim = dimensión de los datos (entero, 1: escalar, 3: vectores, 9: tensores)
% datain= datos a escribir (real, ne x dadadim)
% time = tiempo actual (real)
% timestep = indice de tiempo (entero)

function elementdatablock(fname,ne,dataname,datadim,timestep,time,datain)

fkey=fopen(fname,'a');  % puntero de archivo.
elementdatahead=['$ElementData \n 1 \n', dataname,' \n']; 
fprintf(fkey,elementdatahead);  % encabezado del bloque de datos
%time tags
fprintf(fkey, '1 \n  %6.4e \n', time);  % tiempo actual.
%integer tags, time step, dim, ne
fprintf(fkey, '3 \n %d \n %d \n %d \n',timestep,datadim,ne);
for ii=1:ne
    thisline=num2str(ii, '%d  ');
    for ji=1:datadim; thisline=[thisline,' ',num2str(datain(ii,ji),'%6.4e')]; end
    fprintf(fkey,[thisline,'\n']);
end
fprintf(fkey,'$EndElementData\n');
fclose(fkey);
