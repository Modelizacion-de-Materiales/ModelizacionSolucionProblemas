function [U,F,frame,reaccion]=loop(long,A,E,C,N)

dx=long/(N-1);
x=[0:dx:long]';
Nodos=[x,zeros(N,2)];
casename=['Problema3, ',num2str(N,'%3d'),'nodos.'];
infofile=['P3_',num2str(N,'%3d'),'.dat'];

F=mkvin(Nodos,infofile,A,E,C);
[NODOS,ELEM,seccion,modulo,gl,us,fr,r,s]=readata(infofile);
% K=ensamble(ELEM,NODOS,gl,modulo,seccion);

% tipo de problema: 2 , barras a tracción.
K = mkrig(2,gl,NODOS,ELEM,modulo,seccion);
Fs=fr'-K(r,s)*us';
ur=K(r,r)\Fs;
U(r,1)=ur; U(s,1)=us;
fs=K(s,:)*U;
reaccion=fs-F(N);
success=writedata(U,'Desplazamientos',infofile);

titul=[];
ux=[];
xx=[];
xto=[];
for i=1:N-1
    xx=NODOS(i,1):(NODOS(i+1,1)-NODOS(i,1))/10:NODOS(i+1,1);
    xto=[xto,xx];
    l=NODOS(i+1,1)-NODOS(i,1);
    a=NODOS(i,1);
    ux=[ux,U(i)*N1(xx-a,l)+U(i+1)*N2(xx-a,l)];
end
frame=plot(xto,ux,NODOS(:,1),U,'o');