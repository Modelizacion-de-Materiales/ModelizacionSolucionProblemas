%function elementdatablock(fname,ne,t,p,dataname,datadim,datain)
%esta funcion escribe los datos de elementos datain, a tiempo t, para el paso p
% fname: nombre del archivo donde se va a guardar (.msh)
% ne: numero de elementos - datos a guardar.
% p : paso temporal a guardar
% t : tiempo a guardar
% dataname: Título de los datos a guardar - string incluyendo las comillas
%           de apertura y cierre
% datadim :  dimensionalidad del dato a guardar
% datain  : dato a guardar

function elementdatablock(fname,ne,t,p,dataname,datadim,datain)

fkey=fopen(fname,'a');
elementdatahead=['$ElementData \n 1 \n', dataname,' \n'];
fprintf(fkey,elementdatahead);
%time tags
fprintf(fkey, '1 \n %6.4e \n', t);
%integer tags, time step, dim, nnodes, num_partition
fprintf(fkey, '3 \n %d \n %d \n %d \n',p,datadim,ne);
for ii=1:ne
    thisline=num2str(ii, '%d  ');
    for ji=1:datadim; thisline=[thisline,' ',num2str(datain(ii,ji),'%6.4e')]; end
    fprintf(fkey,[thisline,'\n']);
end
fprintf(fkey,'$EndElementData\n');
fclose(fkey);