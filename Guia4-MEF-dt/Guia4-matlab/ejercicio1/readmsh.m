function [NODOS,ELEM]=readmsh(filein,type)
 %[NODOS,ELEM,seccion,modulo,gl,us,fr,r,s]
 
fid=fopen(filein,'r');
linel=0;
while ~feof(fid)
    linea=fgetl(fid);
    if strcmp(linea,'$Nodes')
        nnod=strread(fgetl(fid));
        for i=1:nnod
            estenod=strread(fgetl(fid)) ;
            NODOS(estenod(1),:)=estenod(2:3);
        end
    elseif strcmp(linea,'$Elements')
        nel=strread(fgetl(fid));
        for i=1:nel
            estel=strread(fgetl(fid)) ;
            elty=estel(2);
            ntags=estel(3);
            if elty==type % Only interested in the adviced element type
                linel=linel+1;
                ELEM(linel,:)=estel([4:5]+ntags);
            end
        end
    else
        continue
    end
end
fclose(fid);