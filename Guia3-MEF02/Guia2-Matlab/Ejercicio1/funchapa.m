%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Ingeniería En Materiales 2013 %%%%%%%%%%%%%%%%%%%%%%%
%%%%                          Chapa                                    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function [x,y,Tmat,t]=funchapa(Lx,Ly,Nx,Ny,tycc,Tcc)
%
% Resuelve el problema de la chapa en condiciones estáticas de equilibrio
% térmico.
% 
% INPUT ---
% Lx= dimensión horizontal
% Ly= dimensión vertical
% Nx= grilla horizontal
% Ny= grilla vertical
% tycc(i) = 1 indica temperatura fija
% %         = 2 indica flujo fijo
% % % % i  = 1 borde A (izq)
% % % %      2 borde B (der)
% % % %      3 borde C (abajo)
% % % %      4 borde D (arriba)
% Tcc son Condiciones de Contorno (en T o q, segun corresponda)
% en caso de tener el flujo de calor q = Q/(-k) 
% %     donde Q = flujo de calor (con su direcci�n)
% %           k = coeficiente de conductividad t�rmica
% 
% OUTPUT---
% x , y : posiciones de la grilla.
% Tmat  : matriz de temperaturas.
% t : tiempo que se tardó en resolver el sistema

function [x,y,Tmat,t]=funchapa(Lx,Ly,Nx,Ny,tycc,Tcc)


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% inicialización del problema
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Chequeo el tamaño de la grilla.

disp('Leídas las dimensiones de la chapa')
str=['Lx=',num2str(Lx), '   Ly=',num2str(Ly)];
disp(str)
disp('Leídas condiciones de contorno')
disp('Borde  A    B    C    D')
disp(typecc(tycc))
disp(Tcc)

% Ahora defino cuáles son los nodos que estan en cada borde.
% Notar que los vertices pertenecen a los bordes horizontales:
% es solo una convención
% Ojo: matlab no agarra indices cero, por lo que la convencón de índicea
% sería:
% k=i+j*Nx +1;
% y los boredes quedan definidos:

% En número de nodos es (y por lo tanto el tamaño del sistema:
% M=Nx*Ny;

% Inicializo variables.
% Matriz de temperaturas, T(i,j).
Tmat(1:Ny,1:Nx)=0.0;

% Vectores de los bordes.
ka=1:Nx:Nx*(Ny-1);
kb=Nx:Nx:Nx*Ny;

kc=2:Nx-1;
kd=Nx*(Ny-1)+1:Nx*Ny-1;

% Notar que los vértices pertenecen  a los bordes verticales.

% Tamaño de paso
dx=Lx/(Nx-1);
dy=Ly/(Ny-1);
beta=dx/dy;

% Matriz del sistema de ecuaciones:
A(1:Nx*Ny,1:Nx*Ny)=0.0;

% Vector de Temperaturas.
T(1:Nx*Ny)=0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%En este lazo se arma la matriz revisando las condiciones de contorno.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for k=1:Nx*Ny       %La voy a llenar barriendo  por filas.
  
  if(any(ka==k)==1)   %Ta, borde izquierdo
               
    if (tycc(1)==1) % Temp fija
      T(k)=Tcc(1);
      A(k,k)=1.;
    elseif (tycc(1)==2) % flujo fijo. 
      T(k)=2.*dx*Tcc(1)*beta^2;  
      if (k-Nx>=1) ; A(k,k-Nx)=beta^2;end  %Los if que estan acá adentro son 
      A(k,k)=-2.*(beta^2 +1.); % redundancias para asegurar que no me salgo
      if (k+1<=M) ; A(k,k+1)=2.; end % de la matriz.
      if (k+Nx<=M) ; A(k,k+Nx)=beta^2; end
    end
    
  elseif any(kb==k)==1  %borde derecho, kb
    
    if (tycc(2)==1) % Temp fija
      T(k)=Tcc(2);
      A(k,k)=1.;
    elseif (tycc(2)==2) % flujo fijo
      T(k)=-2.*dx*Tcc(2)*beta^2;
      if (k-Nx>=1) ; A(k,k-Nx)=beta^2; end
      if (k-1>=1) ; A(k,k-1)=2.; end
      A(k,k)=-2.*(beta^2 +1.);
      if (k+Nx<=M) ; A(k,k+Nx)=beta^2; end
    end
  
  elseif any(kc==k)==1   %En el borde inferior, kc
    
    if (tycc(3)==1) % Temp fija
      T(k)=Tcc(3);
      A(k,k)=1.;
    elseif (tycc(3)==2) % flujo fijo
      T(k)=2.*dy*Tcc(3)*beta^2;
      if (k-1>=1) ; A(k,k-1)=1.; end  % no quiero interferir en el vertice
      A(k,k)=-2.*(beta^2 +1.);
      if (k+1<=Nx*Ny) ; A(k,k+1)=1.; end
      if (k+Nx<=Nx*Ny) ; A(k,k+Nx)=2.*beta^2; end
    end

  elseif (any(kd==k)==1)  %kd, borde superior
              
    if (tycc(4)==1) % Temp fija
      T(k)=Tcc(4);
      A(k,k)=1.;
    elseif (tycc(4)==2) % flujo fijo
      T(k)=-2.*dy*Tcc(4)*beta^2;
      if (k-Nx>=1) ; A(k,k-Nx)=2.*beta^2; end
      if (k-1>=1) ; A(k,k-1)=2.; end
      A(k,k)=-2.*(beta^2 +1.);
      if (k+1<=M) ; A(k,k+1)=1.;end
    end    
    
 

   else  % Si k no está en ningun borde, 
         % lleno los coeficientes de la ecuación general.
       
      A(k,k-Nx)=beta^2;
      A(k,k-1)=1.;
      A(k,k)=-2.*(beta^2 +1.);
      A(k,k+1)=1.;
      A(k,k+Nx)=beta^2;
    
   end
    
end

% resuelvo el sistema
tic %prendo el cronometro
T=A\transpose(T);
t=[Nx*Ny, toc];     % con tic y toc mido el tiempo que tarda en
                    % resolverse el sistema.
                    % el tiempo queda en la salida.
                    
% Ahora tengo que pasar a matriz el vector de temperaturas.
for i=0:Nx-1
    for j=0:Ny-1
        Tmat(j+1,i+1)=T(i+j*Nx+1);
    end
end

% y por último armo la grilla. 
x=0:dx:Lx;
y=0:dy:Ly;

end
