% function [us,fr,r,s]=mkvin(NODOS,MC,gl,{espesor_chapa, tension_remota})
% Esta función setea las condiciones de vínculo para el problema de la chapa empotrada con una
% tracción distribuida uniformemente en el lado derecho,
%
% NODOS : Posiciones de todos los Nodos
% MC: Matriz de conectividad
% gl: grados de libertad por nodo
% Argumentos extras: para este problema, deben darse el espesor de la chapa y la tensión remota
%         aplicada. 

function [us,fr,r,s]=mkvin(NODOS,MC,gl,varargin)

% recupero las dimensiones de las matrices.
[ nnod dim ]=size(NODOS);
[nels,nnxel]=size(MC);

% variables del problema
esp=varargin{1};
T=varargin{2};

% inicializo variables. 
r=[];
s=[];
us=[];
fr=[];
f=zeros(gl*nnod,1);

% definiciones de los vínculos. 
tol=1e-3; % tolerancia en la determinación del borde. 
bd=20;    % posición del borde derecho.

%fuerza distribuida
% ?

% voy a detectar el borde recorriendo todos los elementos. 
for i=1:nels
    brds=sum( abs(NODOS(MC(i,:))-bd)<=tol );  %detecto el número de nodos del elemento actual
                                              % que estan en el borde. 
    if brds==2                                % si tengo dos nodos en el borde para este elemento,
        n=[];                                 
        for j=1:nnxel                         % recorro todos los nodos del elemento
            if ( abs( NODOS(MC(i,j))-bd )<=tol ) % si el nodo esta en el borde,
                n=[n,MC(i,j)];                   % guardo el índice del nodo
            end
        end
        l=abs( diff( NODOS(n,2) ));             % una vez que tengo los dos nodos,
        f(gl*(n-1)+1)=f(gl*(n-1)+1)+0.5*esp*l*T;  % le sumo la contribucicón del elemento actual 
    end
end


% empotramiento
% recorro todos los nodos
for i=1:nnod
    if (NODOS(i,1)==0) % vínculo en empotrado
        s=[s,gl*(i-1)+1:gl*i]; %guardo las coordenadas del nodo actual
        us=[us;zeros(gl,1)];  % y aclaro que van fijas
    else
        r=[r,gl*(i-1)+1:gl*i];  % en cualquier otro caso los nodos estan libres. 
    end
end

fr=f(r); % guardo esta variable como fuerzas en los nodos libres. 
    
