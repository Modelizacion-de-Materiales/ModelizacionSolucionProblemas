%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    Ingeniería en Materiales 2013                   %%%
%%%%                      EDO - Runge-Kutta orden 4                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Esta función evalúa un paso del método de Runge-Kutta de orden 4.
% Utiliza el formalismo vectorial para resolver ecuaciones de segundo
% orden.
%
% INPUT --
% t_anterior : tiempo del paso anterior.
% Y_anterior : ( x, v) al tiempo t_anterior.
% dt : paso temporal 
% F : handle de la función que determina la ecuación diferencial
%     (dx/dt , dv/dt ) = F(t,v) ;
%
% OUTPUT --
% t_siguiente :  t_anterior + dt
% Y_siguiente : (x, v) a tiempo t_sigiente, va a estar dado por el método.



function [t_siguiente,Y_siguiente] = pasoRK4(t_anterior,Y_anterior,dt,FUN)

t_siguiente = t_anterior + dt ; 

%k1 =dt*FUN(t_anterior, Y_anterior ) ;
k1 =FUN(t_anterior, Y_anterior ) ;
%k2 =dt*FUN(t_anterior + dt/2, Y_anterior + k1/2) ;
k2 =FUN(t_anterior + dt/2, Y_anterior + 0.5*k1*dt) ;
%k3 =FUN(t_anterior + dt/2, Y_anterior + k2/2 ) ;
k3 =FUN(t_anterior + dt/2, Y_anterior + 0.5*k2*dt ) ;
%k4 =FUN(t_anterior + dt, Y_anterior + k3 ) ;
k4 =FUN(t_anterior + dt, Y_anterior + k3*dt ) ;

Y_siguiente = Y_anterior + (k1 + 2*k2+2*k3+k4)*dt/6.0 ;

%     k1 = h*feval(f, t(j-1), y(j-1, :));                 % Runge - Kutta
%     k2 = h*feval(f, t(j-1) + h/2, y(j-1, :) + k1/2);    %
%     k3 = h*feval(f, t(j-1) + h/2, y(j-1, :) + k2/2);    %
%     k4 = h*feval(f, t(j-1) + h, y(j-1, :) + k3);        %
%     Y(1,:) = y(j-1, :) + (k1 + 2*k2+2*k3+k4)/6;       %
