function [NODS,MC]=mygetmsh(thismsh)

NODS=getnodos(thismsh);
LIN=getelems(thismsh,1);
TRI=getelems(thismsh,2);
PUN=getelems(thismsh,15);

MC={PUN,LIN,TRI};

end

function MCONEC=getelems(thismsh,elty)

fid=fopen(thismsh,'r');
done=0; % indicar si se han leido todos los nodos

if (elty==1)
    n_nxel=2; %Líneas
elseif (elty==2)
    n_nxel=3; %triangulos
elseif (elty==15) 
    n_nxel=1; % puntos
end

while (~feof(fid) )
    line=fgetl(fid);
    if regexp(line,'\$Elements');break;end
end
ne_parcial=strread(fgetl(fid));

true_el_counter=0; %Count elements that are the asked type
MCONEC=[];
for i=1:ne_parcial
    thiselem=strread(fgetl(fid));
    numtags=thiselem(3);
    if (thiselem(2) == elty )
        true_el_counter=true_el_counter+1;
        MCONEC(true_el_counter,:)=thiselem(3+numtags+1:end);
    end
end

end