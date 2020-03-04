function [NODOS,ELEM,seccion,modulo,gl,uvin,fvin,inc,vin]=readata(filein)
% [nodos,elementos,vin,uvin,inc,fvin]

fid=fopen(filein);
uvin=[];
vin=[];
inc=[];
fvin=[];

while ~feof(fid);
    linea=strtrim(fgetl(fid));
    if regexpi(linea,'^[\#]||^[\%]') % ) % || linea=='' )
        continue;
    elseif regexpi(linea,'[0-9]+ Elementos*')
        nelem=strread(linea,'%d',1);
    elseif regexpi(linea,'[0-9]+ Grados de li[bv]ertad*')
        gl=strread(linea,'%d',1);
    elseif regexpi(linea,'[0-9]+ Nodos$')
        nnodo=strread(linea,'%d',1);
    elseif regexpi(linea,'[0-9]+ Nodos por Elemento')
        nnxel=strread(linea,'%d',1);
    elseif strcmpi(linea,'Nodos')
        NODOS=zeros(nnodo,2);
        i=0;
        while i<nnodo
            estenodo=strtrim(fgetl(fid));
            if regexpi(estenodo,'^[\#]||^[\%]') % ) % || linea=='' )
                continue;
            else
                i=i+1;
                [uvin,fvin,inc,vin,NODOS(i,:)]=getvinsfromnod(uvin,fvin,inc,vin,gl,estenodo);
            end
        end
    elseif strcmpi(linea,'Elementos')
        ELEM=zeros(nelem,nnxel);
        i=0;
        while i<nelem
            estelem=strtrim(fgetl(fid));
            if regexpi(estelem,'^[\#]||^[\%]') % ) % || linea=='' )
                continue;
            else
                i=i+1;
                [ELEM(i,1:nnxel),seccion(i),modulo(i)]=gethisel(estelem,nnxel);
            end
        end
    end
end

