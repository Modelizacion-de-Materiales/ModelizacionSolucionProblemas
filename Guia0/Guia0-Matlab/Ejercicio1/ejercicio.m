% abrir los datos
hold off
close all

XY=load('datos.dat');
n=size(XY,1);
ka = -0.01/0.01 ; %%% cal /s m


% Para encontrar las derivadas numéricas necesito esta matriz:

D = zeros(n,n);
D(1,1:2)=[ -1  , 1 ];
for i = 2:n-1
    D(i,i-1:i+1)=[-1 0 1 ];
end
D(n,n-1:n)=[-1 1];

% luego calculo los deltas
dx=D*XY(:,1);
dy=D*XY(:,2);
ddy=D*dy;
%y las derivadas:
DY = dy./dx;
dDY= D*DY; 
DDY=dDY./dx;



%%
%calular los coeficientes del spline.
[P,xy]=misplines(XY(:,1),XY(:,2),'funcion');
%%
% calcular la interpolación de las derivadas
[DP,dxy]=misplines(XY(:,1),DY,'derivada');
[DDP,ddxy]=misplines(XY(:,1),DDY,'derivada_segunda');

%% encontrar los ceros de la rerivada
[zox,zoy,err]=findzero(ddxy(:,[1,2]));
[zomx,zomy,err2]=findzero(xy(:,[1,4]));
% en esta sección evalúa los ceros de la derivada (mas que nada para que
% quede bien el gráfico.
%primero me fijo en que intervalo esta y despues busco los ceros del
%polinomio correspondiente.
% I=findinterval(zox,XY(:,1));

%%
% para hallar el thermocline puedo evaluar la interpolación de la derivada
% en el lugar donde la derivada segunda se hace cero.
% primero tengo que ubicar el punto en el intervalo correspondiente
I=1;
j=1;
for i =1:n-1
    if zox <=XY(i+1,1) && zox>XY(i,1)
        I(j)=i;        
        j=j+1;
    end
end

Im=1;
jm=1;
for i =1:n-1
    if zomx(jm) <=XY(i+1,1) && zomx(jm)>XY(i,1)
        Im(jm)=i;        
        jm=jm+1;
        if jm>length(zomx) ; break ; end
    end
end
% la variable DYo es la que guarda el valor de la derivada en el punto de
% interes
DYo = polyval(DP(I,:),zox-XY(I,1));
% para calcular el lugar de flujo máximo segun las derivadas de los
% polinomios, tengo en cuenta eso:
dP = [3*P(:,1),2*P(:,2),P(:,3)];
for i=1:length(Im)
    DYom(i) = polyval(dP(Im(i),:),zomx(i)-XY(Im(i),1));
end

    

%% grafiquines
plot(XY(:,1),XY(:,2),'ok','markersize',5 );
hold on
plot(xy(:,1),xy(:,2),'k','DisplayName','Interpolacion');
plot(XY(:,1),DY,'ro',dxy(:,1),dxy(:,2),'r','DisplayName','Primera Derivada');
plot(XY(:,1),DDY,'bo',ddxy(:,1),ddxy(:,2),'b','DisplayName','Segunda Derivada');
plot(zox,zeros(length(zox),1),'ok','markersize',5,'linewidth',2,'DisplayName','Ceros de la segunda derivada');
plot(zox,DYo,'og','linewidth',3,'displayname','Flijo maximo')
legend('location','NorthOutside');
title('Derivadas halladas numericamente de los datos');
saveas(gcf,'curvas.pdf','pdf');
%legend();
% ahora quiero encontrar el lugar donde la derivada primera tiene un
% extremo.
% es aquel lugar donde la derivada segunda tiene un cambio de signo.


%% voy a graficar las derivadas como vienen dadas por la interpolación

fig2=figure(2);
plot(XY(:,1),XY(:,2),'ok','markersize',5 );
hold on
plot(xy(:,1),xy(:,2),'k','DisplayName','Interpolacion');
plot(xy(:,1),xy(:,3),'r','DisplayName','primera derivada');
plot(xy(:,1),xy(:,4),'b','DisplayName','segunda derivada');
plot(zomx,zeros(length(zomx),1),'ok','markersize',7,'linewidth',2,'DisplayName','Ceros de la segunda derivada');
plot(zomx,DYom,'og','linewidth',3,'displayname','Flijo maximo')
title('Derivadas de la interpolacion');
legend('location','SouthEast');
saveas(fig2,'curvas2.pdf','pdf');


%% corrección.

% se puede ver que esto da problemas. hay que calcular las derivadas
% numericamente. 


