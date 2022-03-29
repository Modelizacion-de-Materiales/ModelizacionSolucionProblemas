%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    Ingenieria en Materiales 2013                   %%%
%%%%                EDO - Runge-Kutta orden 4 vectorial                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function [t, y] = rukuvectorial(f, a, b, yo, h)
% Resuelve la ecuación diferencial 
% y' = f(x,y)
% por el método de Runge-Kutta de orden 4. Utiliza el formalismo vectorial
% para reducir ecuaciones de orden superior a orden 1.
%
% INPUT --
% f : handle de la función que define la ecuación, i.e. @nombre_funcion
% [a b] : intervalo donde se quiere resolver la función, i.e. a <= t <= b
% yo :  condición inical para todas las variables. i.e. posicion,
%       velocidad a tiempo cero. se lee 'i cero'
% h : valor del paso de discretización de la variable independiente. 
%
% OUTPUT --
% t :  vector con los valores de variable dependiente. 
% y :  vector con la solución y(t)
%
%


function [t, y] = rukuloop(fun, a, b, yo, h)

%asigno las condiciones iniciales

% tiempo inicial.
t(1)=a;                   

% la condicion inicial
y(1,:) = yo;              

j=1;                      % contador
flag=1;                   % condición de corte.

while flag==1
    [ T , Y(1,:) ] = pasoRK4( t(j), y(j,:), h , fun ) ;
    
    if ( T > b )  % si me paso del intervalo de interes
        flag=2;              % corto el cálculo
    else
        t(j+1)=T;            % si no tengo que cortar, voy al paso siguiente.
        y(j+1,:)=Y(1,:);
    end
    j=j+1;
end

% transpongo el vector de tiempos para que sea columna.
t=t';
