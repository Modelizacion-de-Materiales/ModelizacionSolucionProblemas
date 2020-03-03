function [U,F,frame]=loop(long,A,E,C,N)

dx=long/(N-1);
x=[0:dx:long]';
Nodos=[x,zeros(N,2)];
casename=[num2str(N,'%3d'),'nodos.'];
infofile=['P3_',num2str(N,'%3d'),'.dat']; % genero el archivo de malla. 

Fin=mkvin(Nodos,infofile,A,E,C);  %%% fuerzas externas. 
[NODOS,ELEM,seccion,modulo,gl,us,fr,r,s]=readata(infofile);
[n_n,dim]=size(NODOS);
[n_el,n_nxel]=size(ELEM);

K=zeros(n_n*gl);
for el=1:n_el
    i=ELEM(el,1);
    j=ELEM(el,2);
    nods=NODOS([i,j],:);
    Kel=mkel(casename,3,nods,el,gl,[modulo(el),seccion(el)]);
    K=ensamble2(casename,[i,j],gl,K,Kel);
end


ur=K(r,r)\(fr'-K(r,s)*us');
U(r,1)=ur; U(s,1)=us;
fs=K(s,:)*U;
F=zeros(gl*N,1);  % inicializo las fuerzas totales. 
F(s)=fs;
F(r)=fr;
Reacciones = F - Fin ; % las reacciones son la dif entre las fuerzas totales y las fuerzas externas. 
%reaccion=fs+F(N);
success=writedata(U(1:2:end),'Desplazamientos',infofile);
success=writedata(U(2:2:end),'Angulos',infofile);
success=writedata(F(1:2:end),'Fuerzas',infofile);
success=writedata(F(2:2:end),'Momentos',infofile);
titul=[];
ux=[];
xx=[];
xto=[];
for i=1:N-1
    xx=NODOS(i,1):(NODOS(i+1,1)-NODOS(i,1))/10:NODOS(i+1,1);
    xto=[xto,xx];
    l=NODOS(i+1,1)-NODOS(i,1);
    a=NODOS(i,1);
    ni=gl*(i-1)+1;
    y=U(ni)*N1(xx-a,l)+U(ni+1)*N2(xx-a,l)+U(ni+2)*N3(xx-a,l)+U(ni+3)*N4(xx-a,l);
    ux=[ux,y];
end
frame=plot(xto,ux,NODOS(:,1),U(1:gl:end),'ok');
ylabel('Desplazamiento transversal (in)');
xlabel('posición en la barra (in)');
%