function ok=writedata(U,dataname,fname)

fid=fopen(fname,'a');
fprintf(fid,['Resultados ',dataname,'\n']);

for i=1:length(U)
    fprintf(fid,'%d %6.4e \n',i,U(i));
end

ok=1;
