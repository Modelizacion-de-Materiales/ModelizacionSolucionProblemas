function [uvin,fvin,inc,vin,R]=getvinsfromnod(uvini,fvinin,incin,vinin,gl,nodo);

nvin=length(vinin);
ninc=length(incin);
uvin=uvini;
fvin=fvinin;
inc=incin;
vin=vinin;

estainfo=strread(nodo);
n=estainfo(1);
R=estainfo(1+1:gl+1);
vins(1:gl)=estainfo(gl+2:2*gl+1);
U=estainfo(2*gl+2:3*gl+1);
F=estainfo(3*gl+2:4*gl+1);

for j=1:gl
    if (vins(j)>0)
        nvin=nvin+1;
        vin(nvin)=vins(j)+(n-1)*gl;
        uvin=[uvin,U(j)];
    elseif (vins(j)<0)
        ninc=ninc+1;
        inc(ninc)=-vins(j)+(n-1)*gl;
        fvin=[fvin,F(j)];
    end
end