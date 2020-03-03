%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Maestría En Materiales 2012 %%%%%%%%%%%%%%%%%%%%%%%
%%%%                          Chapa                                    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function [xx,yy,Qx,Qy]=flujos(Nx,Ny,x,y,Tmat)
% 
% Esta función calcula los flujos de calor para el resultado de resolver
% la ecuacion de calor en la chapa con las condiciones de contorno dadas. 
%
% INPUT ---
% Nx, Ny : tamaño de la grilla.
% x , y  : posiciones de los nodos dentro de la chapa.
% Tmat   : Matriz de temperaturas T(i,j).
% 
% OUTPUT ---
% xx , yy : grilla de interconección x,y
% Qx, Qy  : Vectores de flujo.
%

function [xx,yy,Qx,Qy]=flujos(Nx,Ny,n_x,n_y,x,y,Tmat)

step_X=max([(Nx-1)/(n_x-1),1]);
step_Y=max([(Ny-1)/(n_y-1),1]);
k=1;
xs=round(1:step_X:Nx);
ys=round(1:step_Y:Ny);
% modifico para tener tambien los flujos en los bordes.
%for i = 1:step_X:Nx         % solo quiero calcular para 5 puntos 
%    for j=1:step_Y:Ny       % en toda la chapa. 
for i = xs
    for j=ys;
       xx(k)=x(i);
       yy(k)=y(j);
       if i==1 && j==1  % esquina inf iz
         Qx(k)=-(Tmat(j,i+1)-Tmat(j,i))/(x(i+1)-x(i));
         Qy(k)=-(Tmat(j+1,i)-Tmat(j,i))/(y(j+1)-y(j));
       elseif i==1 && j==Ny  % esquina sup iz
         Qx(k)=-(Tmat(j,i+1)-Tmat(j,i))/(x(i+1)-x(i));
         Qy(k)=-(Tmat(j,i)-Tmat(j-1,i))/(y(j)-y(j-1));
       elseif i==Nx && j==1
         Qx(k)=-(Tmat(j,i)-Tmat(j,i-1))/(x(i)-x(i-1));
         Qy(k)=-(Tmat(j+1,i)-Tmat(j,i))/(y(j+1)-y(j));
       elseif i==Nx && j==Ny
         Qx(k)=-(Tmat(j,i)-Tmat(j,i-1))/(x(i)-x(i-1));
         Qy(k)=-(Tmat(j,i)-Tmat(j-1,i))/(y(j)-y(j-1));
       elseif i==1
         Qx(k)=-(Tmat(j,i+1)-Tmat(j,i))/(x(i+1)-x(i));
         Qy(k)=-(Tmat(j+1,i)-Tmat(j-1,i))/(y(j+1)-y(j-1));
       elseif i==Nx
         Qx(k)=-(Tmat(j,i)-Tmat(j,i-1))/(x(i)-x(i-1));
         Qy(k)=-(Tmat(j+1,i)-Tmat(j-1,i))/(y(j+1)-y(j-1));
       elseif j==1
         Qy(k)=-(Tmat(j+1,i)-Tmat(j,i))/(y(j+1)-y(j));
         Qx(k)=-(Tmat(j,i+1)-Tmat(j,i-1))/(x(i+1)-x(i-1));
       elseif j==Ny
         Qy(k)=-(Tmat(j,i)-Tmat(j-1,i))/(y(j)-y(j-1));
         Qx(k)=-(Tmat(j,i+1)-Tmat(j,i-1))/(x(i+1)-x(i-1));
       else
         Qx(k)=-(Tmat(j,i+1)-Tmat(j,i-1))/(x(i+1)-x(i-1));
         Qy(k)=-(Tmat(j+1,i)-Tmat(j-1,i))/(y(j+1)-y(j-1));
       end
       k=k+1;
    end 
end


       
