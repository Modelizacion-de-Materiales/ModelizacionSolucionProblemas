% Esta función escribe la geometría de una barra de longitud L dividida en
% N elementos.

function fid=writegeo(L,N,filename)
dL=L/N;

[points,circles,lines,loops,surfs]=mkcentered();

npoints=size(points,1);
ncircles=size(circles,1);
nlines=size(lines,1);
nloops=size(loops,2);
nsurf=size(surfs,1);

fid=fopen(filename,'w');
for i=1:npoints
    fprintf(fid,'Point (%d)={%6.4f,%6.4f,%6.4f,%6.4f};\n',i,points(i,:));
end
for i=1:ncircles
     fprintf(fid,'Circle (%d)={%d,%d,%d};\n',i,circles(i,:));
end
for i=1:nlines
    fprintf(fid,'Line (%d)={%d,%d};\n',ncircles+i,lines(i,:));
end
for i=1:nloops
    thisloop=loops{i};
    fmt='Line Loop(%d)={';
    for j=1:length(thisloop)-1;
        fmt=[fmt,'%d,'];
    end
    fmt=[fmt,'%d};\n'];
    fprintf(fid,fmt,nlines+ncircles+i,thisloop(:));
end
for i=1:nsurf
    fprintf(fid,'Plane Surface (%d)={%d};\n',ncircles+nlines+nloops+i,surfs(i,:));
end
fclose(fid);


    function [points,circles,lines,loops,surfs]=mkcentered()
        points=[];
        for x=0:dL:L;
            points=[points; x,0,0,2*dL ];
        end
        circles=[];                           % No hay círculos.
        lines=[]; %preparo las líneas.
        for k=1:N
            lines=[lines;k,k+1 ];       % linea 16
        end
        loops={}; % No hay Loops
        surfs=[ ]; % No hay superficies.
    end
end

    
    
        
        
        