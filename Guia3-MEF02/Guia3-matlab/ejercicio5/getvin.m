function [vin,uvin,inc,fvin]=getvin(nodos,gl)

fid=fopen('vinculos.txt');
nvin=0;
ninc=0;
nnod=size(nodos,1);
tol=1e-2;
inc=[];
vin=[];
incaux=[];

while ~feof(fid)
    line=strtrim(fgetl(fid));
    if line(1)=='#'
        continue
    else
        thisvin=strread(line);
        rvin=thisvin(1:3);
        for i=1:nnod
            if norm(nodos(i,:)-rvin) <= tol              
                for j=1:gl
                    estegl=abs(thisvin(3+j));
                    if thisvin(3+j) > 0
                      nvin=nvin+1;
                      vin(nvin)=estegl+(i-1)*gl;
                      uvin(nvin)=thisvin(3+gl+j);
                    elseif thisvin(3+j)<0
                      ninc=ninc+1;
                      inc(ninc)=estegl+(i-1)*gl;
                      fvin(ninc)=thisvin(3+gl+j);
                    end
                end
            %else
            %    incaux(length(incaux)+1)=i;
                
            end
        end
    end
end

for i=1:nnod*gl
    if (~any(vin==i) && ~any(inc==i) )
        ninc=ninc+1;
        inc(ninc)=i;
        fvin(ninc)=0;
    end
end
AUX = sortrows([inc',fvin'],1);
inc=AUX(:,1)';
fvin=AUX(:,2)';
