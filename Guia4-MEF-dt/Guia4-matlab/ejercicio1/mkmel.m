% function M=mkmel(gl,caso,NODOS,MC,rho,A,L)
% Función para hacer la matriz de masa del elemento dado. 
%
% gl: grados de libertad
%
% caso: indica el tipo de matriz de masa.
%      = 1 :  masa consistente barra a tracción
%      = 2 :  masa concentrada barra a tracción
%      = 3 :  masa consistente viga (flección)
%      = 4 :  masa concentrada viga (fección)
%
% NODOS: 
function M=mkmel(gl,caso,NODOS,MC,rho,A,L)

nnod=size(NODOS,1);
[ nel nnxel ] = size(MC);
M=zeros(nnod*gl);
for i=1:nel
    thisel=MC(i,:);
    nodlocal=NODOS(thisel,:);
    r1=nodlocal(1,:);
    r2=nodlocal(2,:);
    L=norm(r2-r1);
    
    if caso==1 && gl==1
        Mloc=[2 1 ; 1 2]*rho*A*L/6; % matriz de masa consistente
        
    elseif caso==2 && gl==1
        Mloc=[1 0 ; 0 1 ]*rho*A*L/2; % matriz de masa reducida.
        
    elseif caso==3 && gl==2  % matriz de maa consistente, flección
        Mloc=[156    22*L    54    -13*L ; ...
              22*L   4*L^2   13*L  -3*L^2; ...
              54      13*L   156   -22*L ; ...
              -13*L   -3*L^2 -22*L  4*L^2]*rho*A*L/420 ;
          
    elseif caso==4 && gl==2
        Mloc=[];  %matriz de masa concentrada
    end

    M=ensamble(thisel,nodlocal,M,Mloc,gl);
    
end
