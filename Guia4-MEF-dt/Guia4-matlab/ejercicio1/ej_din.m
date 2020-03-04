gl=2; %grados de libertad.
E=210e9; %Pa
L=1; %m de longitud
A=10e-4; %m^2, área.
I=(10*1e-2)^4; % momento de inercia.
rho=7850; % densidad kg m^-3;
tol = 1e-3;
gl=2;
nsteps=20; % cantidad de pasos temporales por período.
n_nodo=25 ; % numero de nodos , 
n_el = n_nodo - 1 ; % numero de elementos. 
% y multiplico los modulos. 
areas=A*ones(1,n_el);
modulos=E*ones(1,n_el);
inercias=I*ones(1,n_el);
densidades=rho*ones(1,n_el);

% Generacion de la posición de los nodos.
X=[0:L/(n_nodo-1):L]';

% Matriz de Nodos:
NOD=[ X  zeros( n_nodo, 2 ) ];

% Generación de la Matriz de Conectividad.
MC=zeros(n_el,2);
for i=1:n_el
    MC(i,:)=[i,i+1];
end

%% armo las Matrices

K = mkrig(3,gl,NOD,MC,modulos,inercias,areas); % matriz de rigidez para barras a flección
M = mkmasg(3,gl,NOD,MC,densidades,areas);

% s=[1,2];
% r=[3:n_nodo*gl];
% Us=[0;0];
[us,fr,r,s]=mkvin(NOD,MC,gl);



%% Solución de los modos.
[Ur,W2]=eig(K(r,r),M(r,r));
n_mods=size(Ur,2);
W=sqrt(diag(W2));

D=zeros(n_mods+length(s),n_mods);
Y=zeros(n_nodo,n_mods);
%% ploteo sencillo

for i = 1:n_mods; 
    D(s,i)=us;
    D(r,i)=Ur(:,i)/Ur(end-1,i);
    Y(:,i)=D(1:gl:end,i);
end
    
hold all
% Escribo los cuatro primeros modos en sus msh's.
for i = 1:4
    clear modefile Ut Desps 
    plot(X,Y(:,i));
    modefile=['modo-',num2str(i),'.msh'];
    writemsh(NOD,MC,modefile);
    T=2*pi/W(i);
    dt(i)=T/(nsteps-1);
    for j=1:nsteps
        Ut=Y(:,i)*cos(W(i)*(j-1)*dt(i));
        Desps=[zeros(n_nodo,1),Ut,zeros(n_nodo,1)];
        nodedatablock(modefile,n_nodo,'"Desplazamientos"',3,j-1,(j-1)*dt(i),Desps);
    end
        
end
