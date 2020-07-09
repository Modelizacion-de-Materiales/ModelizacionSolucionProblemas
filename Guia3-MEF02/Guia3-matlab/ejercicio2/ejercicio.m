%% Inicializar variables generales
gl=2; %grados de libertad
E=30e6; %psi
nu=0.3;
t=1; %inch
sigma_ext=1000; % tension remota, psi

thiscase='chapa2_1cuad';  %nombre del caso actual.
%writegeo(0,1,-10,10,-5,5,2,10,[thiscase,'.geo']);
%system(['gmsh ',thiscase,'.geo -2 -o ',thiscase,'.msh'])
[NOD,MC]=readmsh([thiscase,'.msh']);  % obtener nodos y matriz de conectividad.
ngl=size(NOD,1)*gl;   % numero totales de grados de libertad.
nnodo=size(NOD,1);   % número de nodos total
[nels nnxel]=size(MC);  % número de elementos, numero de nodos por elemento
modulos=E*ones(nels,1); %%%%
poisson=nu*ones(nels,1);   %  Modulos. 
espesores=t*ones(nels,1);%%%

%% Resolución
[us,fr,r,s]=mkvin(NOD,MC,gl,t,sigma_ext,-10,10,5,-5); % hacer vínculos.
K=mkrig(4,gl,NOD,MC,modulos,poisson,espesores); %Hacer matríz para triangulos lineales.
fs=fr-K(r,s)*us;
ur=K(r,r)\fs; % Resolver propiamente.

%% levantar resultado y calcular cosas.
U=zeros(ngl,1); U(r)=ur; U(s)=us; Ux=U(1:gl:ngl); Uy=U(2:gl:ngl);% desplazamientos.
F(r)=fr;
Ft=F';
save('fuerzas-mariano.dat','Ft','-ascii')
F(s)=K(s,:)*U; Fx=F(1:gl:ngl);Fy=F(2:gl:ngl);% todas las fuerzas.
tensiones=getsigma(U,NOD,MC,E,nu,t);
% tensiones principales:
A=(tensiones(:,1)+tensiones(:,2))/2;
B=sqrt( (tensiones(:,1)-tensiones(:,2) ).^2/4 + tensiones(:,3).^2 );
principales=[ A+B , A-B , tensiones(:,3) ];
%calcular las tensiones promedio en los nodos.
sigmax_nod=tennod(nnodo,MC,principales(:,1));
sigmay_nod=tennod(nnodo,MC,principales(:,2));
shear_nod=tennod(nnodo,MC,principales(:,3));

%% Escribir msh base, sobreescribe el generado anteriormente.
thiscaseout=[thiscase,'-out.msh'];
fid=writemsh(NOD,MC,thiscaseout);
nodedatablock(thiscaseout,nnodo,'"sigma x (Pa,av) " ',1,0,0.0,sigmax_nod);
nodedatablock(thiscaseout,nnodo,'"shear (Pa,av) " ',1,0,0.0,shear_nod);
nodedatablock(thiscaseout,nnodo,'"Desplazamiento (m) " ',3,0,0.0,[Ux Uy zeros(nnodo,1)] );
nodedatablock(thiscaseout,nnodo,'"Fuerzas (N) " ',3,0,0.0,[Fx' Fy' zeros(nnodo,1)] );
nodedatablock(thiscaseout,nnodo,'"F_x (N) " ',3,0,0.0,[Fx' zeros(nnodo,2)] );
nodedatablock(thiscaseout,nnodo,'"F_y (N) " ',3,0,0.0,[zeros(nnodo,1) Fy' zeros(nnodo,1)] );
elementdatablock(thiscaseout,nels,'"Tensiones 1(Pa)"',1,0,0.0,principales(:,1))
