%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    Ingeniería en Materiales 2013                   %%%
%%%%                      Guía 1 ejerciico 3                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

xmin=0;         % Voy a resolver entre to y tmax
xmax=4;     
xo=0;   % las condiciones iniciales de altura y velocidad.
yo=2;
h=2;          % el paso.
tol=1e-4;     % tolerancia en el error

% Lo que quiero es ver el tamaño de paso óptimo para el peor de los
% métodos.

str='';
i=1;
titles='';
ereu(1)=1;
errk(1)=1;
erhe(1)=1;
h(1)=2;

% voy a ir cambiando el paso hasta que el error dados por ambos métodos sea
% despreciable (menor que la tolerancia).
i = 1;

while ( ereu(end) > tol ||  errk(end) > tol ) && i < 100
    
    %Limpio las variables del paso anterior.
    clear xeu yeu xrk yrk yteok 
    
    % evalúo un paso nuevo.
    i=i+1;
    
    % actualizo el paso. La modificación es logarítmica para poder tener 10
    % púntos por década.
    h(i)=h(i-1)*10^(-0.1);
     
% Resuelvo por Euler y mido el error. 
%    [teu,xeu,veu]=funparac(@euloop,to,tmax,[xo,vo],h(i));
    [xeu,Yeu]=euloop(@F,xmin,xmax,yo,h(i));
    ereu(i)=abs(Yeu(end) - fteorica(xeu(end)) ) / abs( Yeu(end) );
    esfeu(i)=length(Yeu);

% resuelvo por Heun y mido el error
%    [trk,xrk,vrk]=funparac(@rukuvectorial,to,tmax,[xo,vo],h(i));
    [xhe,Yhe]=heunloop(@F,xmin,xmax,yo,h(i));
    erhe(i)=abs(Yhe(end) - fteorica(xhe(end)) )/ abs( Yhe(end) );        
    esfhe(i)=2*length(Yhe);
    
% resuelvo por Runge-Kutta y mido el error
%    [trk,xrk,vrk]=funparac(@rukuvectorial,to,tmax,[xo,vo],h(i));
    [xrk,Yrk]=rukuloop(@F,xmin,xmax,yo,h(i));
    errk(i)=abs(Yrk(end) - fteorica(xrk(end)) )/ abs( Yrk(end) );    
    esfrk(i)=4*length(Yrk);
    
    % muestro evolución. 
    disp(['Done for h= ',num2str(h(i)),'; ereu=',num2str(ereu(i)), ...
        '; erhe=',num2str(erhe(i) ),'; errk=',num2str(errk(i) )] )
end

%%
close all
% Ahora voy a hacer el gráfico.
% en grafíco doble logarítmico, grafico el error que da el método de Euler.
loglog(esfeu,ereu,'--sk','linewidth',2,'markerfacecolor','red','markersize',5);

%En el mismo gráfico 
hold on;
% grafíco el error dado por el método de Heunn. 
loglog(esfhe,erhe,'--dk','linewidth',2,'markerfacecolor','yellow','markersize',5);
% grafíco el error dado por el método de Runge-Kutta. 
loglog(esfrk,errk,'-ok','linewidth',2,'markerfacecolor','green','markersize',5);

leg1=legend('Euler','Heunn','R-K (4)');
set(leg1,'Location','southWest','FontSize',18);

mitit=num2str(fteorica(xrk(end)),' valor de y_{teo}(4) = %3.8e ');
title(mitit);
miylab='abs( (y(4)-y_{teo}(4))/y_{teo}(4) )';
ylabel(miylab);
xlabel('esfuerzo, numero de evaluaciones de la funcion');

%guardo el gráfico en un  pdf.
saveas(gcf,'errores.pdf','pdf');

% cierro el gráfico. 
hold off;