function [U,F]=loop(long,A,E,k,N)

dx=long/(N-1);
x=[0:dx:long]';
Nodos=[x,zeros(N,2)];
casename=['Problema3, ',num2str(N,'%3d'),'nodos.'];
infofile=['P3_',num2str(N,'%3d'),'.dat'];

F=mkvin(Nodos,infofile,A,E,k);
[NODOS,ELEM,seccion,modulo,gl,us,fr,r,s]=readata(infofile);
K=ensamble(ELEM,NODOS,gl,modulo,seccion);
Fs=fr'-K(r,s)*us';
ur=K(r,r)\Fs;
U(r,1)=ur; U(s,1)=us;
fs=K(s,:)*U;
F=zeros(gl*N,1);
F(s)=fs;
F(r)=fr;
success=writedata(U(1:2:end),'Desplazamientos',infofile);
success=writedata(U(2:2:end),'Angulos',infofile);
success=writedata(F(1:2:end),'Fuerzas',infofile);
success=writedata(F(2:2:end),'Momentos',infofile);




titul=[];
ux=[];
xx=[];
xto=[];
for i=1:N-1
    clear yx;
    xx=NODOS(i,1):(NODOS(i+1,1)-NODOS(i,1))/10:NODOS(i+1,1);
    xto=[xto,xx];
    l=NODOS(i+1,1)-NODOS(i,1);
    a=NODOS(i,1);
    ni=gl*(i-1)+1;
    yx=U(ni)*N1(xx-a,l)+U(ni+1)*N2(xx-a,l)+U(ni+2)*N3(xx-a,l)+U(ni+3)*N4(xx-a,l);
    ux=[ux,yx];
end
frame=plot(xto,ux,NODOS(:,1),U(1:gl:end),'o');