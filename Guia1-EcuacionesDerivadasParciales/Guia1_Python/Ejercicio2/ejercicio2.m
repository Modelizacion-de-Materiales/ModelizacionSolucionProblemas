
%% carga de datos

L=10; %cm
k=0.835; % cm^2/s , Al
dx=1; %cm, la idea es dejarlo fijo y hacer todo en función de dt.
%dt=0.61379; %seg
dt = 0.6138;  %%% comportamiento critico
%dt=0.6; %%% comportamiento estable
% dt = 0.65 comportamiento inestable.
lambda=k*dt/(dx^2);  % lambda
Ta=100;  % temperatura borde izquierdo
Tb=50;   % temperatura borde derecho
x=0:dx:L; % vector de posiciones
N=L/dx + 1;  % cantidad de nodos.
casename=['Errorslambda',num2str(lambda,'%6.4f')]

%% Resuelvo por C-N
[errCN,TCN,tCN]=solverdf(dt,dx,lambda,N,Ta,Tb,3,1e-2,[1 1]);
tit=methodname(3);
flux_in_CN=-k*(TCN(2,:)-TCN(1,:));
flux_out_CN=-k*(TCN(end,:)-TCN(end-1,:));
%% Resuelvo por Método Explicito
[errEX,TEX,tEX]=solverdf(dt,dx,lambda,N,Ta,Tb,1,1e-2,[1 1]);
tit=strvcat(tit,methodname(1));
flux_in_EX=-k*(TEX(2,:)-TEX(1,:));
flux_out_EX=-k*(TEX(end,:)-TEX(end-1,:));
%% Resuelvo por Método Implicito
[errIM,TIM,tIM]=solverdf(dt,dx,lambda,N,Ta,Tb,2,1e-2,[1 1]);
tit=strvcat(tit,methodname(2));
flux_in_IM=-k*(TIM(2,:)-TIM(1,:));
flux_out_IM=-k*(TIM(end,:)-TIM(end-1,:));
%% Post procesing
lambdatext=['\lambda = ',num2str(lambda,'%6.4f')]
casename=['lambda',num2str(lambda,'%6.4f')];
x=0:dx:L;
%%
h1=figure(1);
% Plotear errores
semilogy(tCN,errCN,tEX,errEX,tIM,errIM);
legend(tit);
% title(['Errores para \lambda = ',num2str(lambda,'%6.4f')],'fontsize',18);
title(['Errores para ',lambdatext],'fontsize',18);

xlabel('tiempo (s)','Fontsize',16);
ylabel('error (C)');
saveas(gcf,['errores',casename,'.pdf'],'pdf');

%%  codigo desechado.
% [Timp,timr,errimp]=feval(@implicito,Ta,Tb,L,dx,dt,k);
%[Texp,timexp,errexp]=feval(@explicito,Ta,Tb,L,dx,dt,k);
% T_t=explicito(Ta,Tb,L,100,dx,dt,k);
%%
%% Grafico de flujos
h2=figure(2);
vertline=flux_out_CN(end)*ones(size(flux_out_CN));
plot(tCN,flux_in_CN,'k','linewidth',2);
hold on
plot(tCN,flux_out_CN,'k--','linewidth',2);
plot(tCN,vertline,'k--','linewidth',1);
title(['Flujos - CN, ',lambdatext]);
xlabel('tiempo (s)');
ylabel('Q (x10^{-2} W /m^2 )');
legend('nodo 1 (entrante)','nodo N (saliente)','Q estacionario');

saveas(h2,['flujos-',casename,'.pdf'],'pdf');
%% comparo flujos
h3=figure(3);
plot(tCN,flux_in_CN,'k','linewidth',2);
hold on
plot(tEX,flux_in_EX,'r','linewidth',2);
LEGS=strvcat('C-N','Explicito');
xlabel('tiempo (s)','FontSize',14);
ylabel('Q (x10^{-2} W /m^2 )','FontSize',14);
%legend('C-N','Explicito');
myleg=legend(LEGS);
set(myleg,'FontSize',12,'box','off')

title(['Comparacion flujos ',lambdatext],'FontSize',14);
ylim(flux_in_CN(end)*[0.5,1.5]);
xlim(max(tCN)*[0.75,1]);
saveas(h3,['comparflux',casename,'.pdf'],'pdf');

%% Ultimo grafico interesante
h4=figure(4);
stepplot=floor(length(tCN)/8);  %%% quiero dibujar solo 8 curvas.
dtleg=['\DELTA t = ',num2str(stepplot,3)]
plot(0:dx:L,TCN(:,1:stepplot:end),'k-','linewidth',2 )

hold on

plot(0:dx:L,TCN(:,end)-5,'k--')
plot(0:dx:L,TCN(:,end)+5,'k--')

% hold on
%  h4b=quiver(4,TCN(4,1),0,TCN(4,stepplot-1),'r','linewidth',2);
%  set(h4b,'MaxHeadSize',0.05);
title(['Evolucion para C-N, ',lambdatext]);

saveas(h4,['perfiles-',casename,'.pdf'],'pdf')
