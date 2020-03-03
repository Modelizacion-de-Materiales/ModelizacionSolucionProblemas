%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    Ingenieria en Materiales 2013                     %%%
%%%%                      EDO - Paracaidista                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

%% Definición de las constantes del problema.
% paso 
dx= 1.0;

% extremos
xmin = 0; xmax = 4;

% condiciones iniciales
y(1) = 2; x(1) = 0;     % condiciones iniciales

% Inicializo las soluciones de Euler, Heunn y RK4 con las condiciones iniciales de posición
Yeu(1,:) = y ;Yhe(1,:) = y ;Yrk(1,:) = y ;


%% Iteración
i = 1;
flag=true;
while flag
    i = i+1 ;
    % i=1 es la condición incial. i es solo un contador que me define el índice.
    x(i) = x(i-1) + dx;% nuevo tiempo
    % Paso Euler
    [xaux, Yeu(i,:) ]= pasoEU(x(i-1),Yeu(i-1,:), dx , @F ) ;
    % paso Heunn
    [xaux, Yhe(i,:) ]= pasoHE(x(i-1),Yhe(i-1,:), dx , @F ) ;
    % Paso RK
    [xaux,Yrk(i,:)] = pasoRK4( x(i-1) , Yrk(i-1,:) , dx ,  @F) ;
    
    if x(end) >= xmax
        flag = false;
    end
end


xteo=xmin:(xmax-xmin)/99:xmax;
yteo = fteorica(xteo);

yteox=fteorica(x)
%% Imprimo algunas cosas para ver como voy
disp('    tiempo    euler  Heunn   R-K(4)  Teórica  ')
disp('=========================================')
disp([x',Yeu(:,1), Yhe(:,1), Yrk(:,1), yteox' ]);

%% grafiquin
close all
hold off
plot(xteo,yteo,'-k','linewidth',2,'displayname','Solucion Teorica');
hold on
plot(x,Yeu(:,1),'-ob','linewidth',1,'markersize',5,'Displayname','Euler');
plot(x,Yhe(:,1),'-og','linewidth',1,'markersize',5,'displayname','Heunn');
plot(x,Yrk(:,1),'-or','linewidth',1,'markersize',5,'displayname','Runge - Kutta');
legend('location','northwest');
xlabel('x','fontsize',14);
ylabel('y(x)','fontsize',14);
tit=[' Comparar Soluciones dx = ',num2str(dx,3) ];
fname=['soluciones',num2str(dx,3),'.pdf'];
title(tit,'fontsize',16);
saveas(gcf,fname,'pdf');
