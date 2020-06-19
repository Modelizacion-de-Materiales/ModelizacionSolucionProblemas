
%% Inicializar variables generales
gl=1; %grados de libertad.
L=0.1; %m de longitud
A=pi*(6e-3)^2 ; %m^2, área.
k=200; % W/mC, conductividad térmica.
% ojo que despues piso la C
C=900; % J/kgC, calor especifico.
rho=2700; % densidad kg m^-3;
tol = 1e-3;
N=5; % Número de Nodos
x=0:L/(N-1):L;
dt=0.5; % seg, intervalo temporal
t=0; % tiempo inicial.
thiscase='barra';
T=30*ones(N,1); % Temperatura inicial.
writegeo(L,N-1,[thiscase,'.geo']);  % hacer la geometría
system('rm *.msh');
system(['gmsh -1 -format msh22 ',thiscase,'.geo ',thiscase,'.msh']); %hacer el msh
[NOD,MC]=readmsh([thiscase,'.msh'],1);  % obtener nodos y matriz de conectividad, solo para líneas.
ngl=size(NOD,1)*gl;   % numero totales de grados de libertad.
nnodo=size(NOD,1);   % número de nodos total
[nels nnxel]=size(MC);  % número de elementos, numero de nodos por elemento
% Los únicos vínculos se deben a temperaturas fijas en los extremos.
[us,fr,r,s]=mkvin(NOD,MC,gl); % hacer vínculos.
K=mkrigid(MC,NOD,gl,k); %Hacer matríz de rigidez.
dlmwrite('Mat-rigidez.dat',K,'delimiter',' ','precision','%6.4e');
C=mkmasa(gl,1,NOD,MC,rho,C); %hacer matriz de capacitancia consistentes.
dlmwrite('Mat-capacitancia.dat',C,'delimiter',' ','precision','%6.4e');
% Sobreescribir el msh.
fid=writemsh(NOD,MC,[thiscase,'.msh']);
nodedatablock([thiscase,'.msh'],nnodo,0,0.0,'"Temperature (C)"',1,T(:,1));
plotframe(x,T(:,1),['t= ',num2str(0),' seg'],'barra.gif',1);
%fs=fr-K(r,s)*us; ur=K(r,r)\fs; % Resolver propiamente. Esto no es un
%% time integration
fid=fopen('flux.dat','w');
fprintf(fid,'# time (s) ,  q1,   q2  \n');
for i=2:10000
    T(s,i)=us;
    T(r,i)=T(r,i-1)-C(r,r)\( dt*( K(r,r)*T(r,i-1)+K(r,s)*T(s,i-1) ) );
    nodedatablock([thiscase,'.msh'],nnodo,i-1,(i-1)*dt,'"Temperature (C)"',1,T(:,i));
%    plotframe(x,T(:,i),['t= ',num2str((i-1)*dt),' seg'],'barra.gif',i);
    %% medición del flujo en los extremos!
    partialT(:,i-1)=(T(:,i)-T(:,i-1))/dt    ;
    fs(:,i-1)=C(s,:)*partialT(:,i-1)+K(s,:)*T(:,i-1);
    fprintf(fid,'%6.4e  %6.4e  %6.4e \n',(i-1)*dt,fs(1,i-1),fs(end,i-1));
end
fclose(fid);
partialT(:,i)=partialT(:,i-1);
fs(:,i)=C(s,:)*partialT(:,i)+K(s,:)*T(:,i);

%%
close all;

plot(0:dt:(i-1)*dt,fs(1,:),0:dt:(i-1)*dt,fs(end,:));
ylim([-1e5 2e5]);
saveas(gcf,'flujos.pdf','pdf');

    %problema de estática sino uno de autovalores generalizados.
    %% Resolución para matriz consistente.
% end
%% postprocessing
