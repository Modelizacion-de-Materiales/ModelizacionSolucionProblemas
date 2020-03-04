function [uvin,fvin,inc,vin]=mkvin(nodos,MC,gl)

fid=fopen('vinculos.txt');
nnod=size(nodos,1);
tol=1e-2;
inc=[];
vin=[];
uvin=[];
fvin=[];

for i=1:nnod
    if ( sum( sum( MC==i))==0 )
        vin=[vin,gl*(i-1)+1:gl*i];
        uvin=[uvin;zeros(gl,1)];
    elseif abs( nodos(i,1) ) < tol
        vin=[vin,gl*(i-1)+1:gl*i];
        uvin=[uvin;zeros(gl,1)];
    else
        inc=[inc,gl*(i-1)+1:gl*i];
        fvin=[fvin;zeros(gl,1)];
    end
end