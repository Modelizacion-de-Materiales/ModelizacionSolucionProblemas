function [uvin,fvin,inc,vin,R]=getvinsfromnod(uvini,fvinin,incin,vinin,gl,nodo);

nvin=length(vinin);
ninc=length(incin);
uvin=uvini;
fvin=fvinin;
inc=incin;
vin=vinin;

estainfo=strread(nodo);
n=estainfo(1);
R=estainfo(1+1:3);
vins(1:gl)=estainfo(3+1:3+gl);
U=estainfo(3+gl+1:3+2*gl);
F=estainfo(3+2*gl+1:3+3*gl);

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