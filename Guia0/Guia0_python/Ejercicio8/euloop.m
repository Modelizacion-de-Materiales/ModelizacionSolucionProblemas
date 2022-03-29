%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    Ingenieria en Materiales 2013                   %%%
%%%%                       EDO - Método de Heun                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function [x,y]=euloop(fun,a,b,y0,h)
% 
% Esta función resuelve la ecuación diferencial 
% (dx/dt, dv/dt ) = f(x,y) 
% por el método de Euler. Utiliza el formalismo vectorial
% para reducir ecuaciones de orden superior a orden 1.
% 
%
%INPUT --- 
% fun : handle de la función que define la ecuación, i.e. @nombre_funcion
% y0 :  condición inical para todas las variables. i.e. posicion,
%       velocidad a tiempo cero.
% [a b] : intervalo donde se quiere resolver la función, i.e. a <= t <= b
% h : valor del paso de discretización de la variable independiente. 
%
%OUTPUT ---
% x :  vector con los valores de variable dependiente. 
% y :  vector con la solución y(x)
%


function [t,y]=euloop(fun,a,b,yo,h)
% tiempo inicial.
t(1)=a;                   

% la condicion inicial
y(1,:) = yo;             

j=1;                      % contador
flag=1;                   % condición de corte.

while flag==1  

   [ T , Y(1,:) ] = pasoEU( t(j), y(j,:), h , fun ) ;
                         
    if ( T > b )  % si me paso del intervalo de interes
        flag=2;                 % corto el cálculo
    else
        t(j+1)=T;               % si no tengo que cortar, voy al paso siguiente.
        y(j+1,:)=Y(1,:);
    end
    
    j=j+1;
end

% transpongo el vector de tiempos para que sea columna.
t=t';
  
