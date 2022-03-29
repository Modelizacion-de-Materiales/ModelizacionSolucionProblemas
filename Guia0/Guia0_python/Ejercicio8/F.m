%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    Ingeniería en Materiales 2013                   %%%
%%%%                 Ejercicio 3 guia 1 - función                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%function dy=dfparac(t,y)
% esta función es la F(x,y,y') en la ecuación diferencial del paracaidista.
% dy = F(x,y,y')
% 
% INPUT -- 
% t: tiempo actual
% y = [ v, v' ]: 
%


function dy=F(t,y)

dy=4*exp(0.8*t)-0.5*y;