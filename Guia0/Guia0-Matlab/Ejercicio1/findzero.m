function [xo,yo,err]=findzero(datos)

n=size(datos,1);

for i=1:n-1
    criterio(i)=datos(i,2)*datos(i+1,2);
end

i=find(criterio<0);

xo = (datos(i,1)+datos(i+1,1))/2;
yo = zeros(length(i),1);
err= abs(datos(i,1)-datos(i+1,1));