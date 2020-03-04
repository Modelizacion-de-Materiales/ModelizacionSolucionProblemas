%esta funcion escribe los datos de nodo datain, a tiempo t, para el paso p
%nn=numero de nodos.
function nodedatablock(fname,nn,frame,t,dataname,datadim,datain)
fkey=fopen(fname,'a');
nodedatahead=['$NodeData \n 1 \n', dataname,' \n'];
fprintf(fkey,nodedatahead);
%time tags
fprintf(fkey, '1 \n  %6.4f \n',t);
%integer tags, time step, dim, nnodes, num_partition
fprintf(fkey, '3 \n %d \n %d \n %d \n',frame,datadim,nn);
for ii=1:nn
    thisline=num2str(ii, '%d  ');
    for ji=1:datadim; thisline=[thisline,' ',num2str(datain(ii,ji),'%6.4e')]; end
    fprintf(fkey,[thisline,'\n']);
end
fprintf(fkey,'$EndNodeData\n');
fclose(fkey);
end