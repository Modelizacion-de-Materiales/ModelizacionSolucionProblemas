%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Ingeniería En Materiales 2013 %%%%%%%%%%%%%%%%%%%%%%%
%%%%                          Chapa                                    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Problema  general de la chapa. Se inicializan las dimensiones del
% problema y los tipos y condiciones de contorno. 

%Las dimensiones de la chapa son:
Lx=1.;Ly=1.;

%inicializo con este tipo de condiciones de contorno
%tipo_cc=[1,1,2,1]; 
tipo_cc=[2,1,2,1]; 
% Este vector se define de la siguiente manera:
% 
%    tipo_cc ( i )  : condciones de contorno para el borde i
%                   :    i = 1 es borde A  (izquierda)
%                   :    i = 2 es borde B  (derecha)
%                   :    i = 3 es borde C  (abajo)
%                   :    i = 3 es borde D  (arriba) 
%    tipo_cc(i) = 1 : temperatura fija.
%    tipo_cc(i) = 2 : flujo dado.
%    tipo_cc(i) = 3 : perfil de tepmeraturas


% inicializo las condiciones iniciales
%T_bordes=[75.0 , 50.0, 0.0, 100.0 ];
T_bordes=[0.0 , 50.0, 0.0, 100.0 ];

% Primer valor de N  a testear. (dimension de la grilla).
N=3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Ejercicios %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1) A partir de aquí haga un lazo que incremente el tamaño de la grilla hasta
% que el gradiente de temperaturas sea suficientemente suave o bien
% mientras el tamaño del sistema sea manejable.

% 2) Tome los tiempos de ejecución del sistema y grafiquelos. Intente 
% ajustar los tiempos por una función cuadrática (recuerde la clase de 
% cuadrados mínimos). Qué le dice esto ?. 


% Por ejemplo puede ejecutar:
[x,y,Tsol,t]=funchapa(Lx,Ly,N,N,tipo_cc,T_bordes); 

[xx,yy,qx,qy]=flujos(N,N,6,6,x,y,Tsol);              % cálculo de flujos


% un gráfico del último calculo:
    [X,Y]=meshgrid(x,y);                             % hago el mesh
    
    contour(X,Y,Tsol,'Fill','on','linecolor',[0 0 0],'linewidth',1,'levelstep',3.2)

    % grafico el mapa de Ts.
    title(['N = ',num2str(N)],'FontSize',14);  % le pongo un título.
    colorbar   % referencia de temperaturas.
    hold on    % aguanto para agregarle los flujos.
    quiver(xx,yy,qx,qy,'color',[0 0 0],'linewidth',2,'AutoScaleFactor',10)
    %xlim([-0.2 1.2]);
    %ylim([-0.2 1.2]);
    saveas(gcf,['N-',num2str(N),'.pdf'],'pdf');   % guardo el cuadro
    hold off    % suelto para pasar al proximo paso.
