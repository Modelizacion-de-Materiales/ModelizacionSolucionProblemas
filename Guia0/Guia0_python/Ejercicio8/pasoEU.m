%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    Ingenieria en Materiales 2013                     %%%
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



function [t_siguiente,Y_siguiente] = pasoEU(t_anterior,Y_anterior,dt,FUN)

t_siguiente = t_anterior + dt ; 

Y_siguiente = Y_anterior + dt*FUN(t_anterior, Y_anterior ) ;

