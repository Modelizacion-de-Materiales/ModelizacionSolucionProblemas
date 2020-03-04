
%% Inicializar variables generales
gl=2; %grados de libertad
E=30e6; %psi
nu=0.3;
t=1; %inch
sigma_ext=1000; % tension remota, psi
z=0.0;   % Altura del agujero
df=10; % relacion entre los factores de escala
system('rm *.geo *.msh');
for z=0.0:0.5:5
    disp(['Going for z= ',num2str(z,'%4.2f')]);
    %% loop
    thiscase=['z',num2str(z,'%4.2f')];  %nombre del caso actual.
    writegeo(z,1.0,-10,10,-5,5,10,[thiscase,'.geo']);  % hacer la geometría
    system(['gmsh -2 ',thiscase,'.geo ']); %hacer el msh
    %% Leer el msh creado
    [NOD,MC]=readmsh([thiscase,'.msh']);  % obtener nodos y matriz de conectividad.
    ngl=size(NOD,1)*gl;   % numero totales de grados de libertad.
    nnodo=size(NOD,1);   % número de nodos total
    [nels nnxel]=size(MC);  % número de elementos, numero de nodos por elemento
    %% resolución
    [us,fr,r,s]=mkvin(NOD,MC,gl,t,sigma_ext,-10,10); % hacer vínculos.
    K=ensamble(MC,NOD,gl,E,nu,t); %Hacer matríz
    fs=fr-K(r,s)*us; ur=K(r,r)\fs; % Resolver propiamente.
    
    %% levantar resultado y calcular cosas.
    U=zeros(ngl,1); U(r)=ur; U(s)=us; Ux=U(1:gl:ngl); Uy=U(2:gl:ngl);% desplazamientos.
    F(r)=fr; F(s)=K(s,:)*U; Fx=F(1:gl:ngl);Fy=F(2:gl:ngl);% todas las fuerzas.
    %% calcular tensiones
    tensiones=getsigma(U,NOD,MC,E,nu,t);
    A=(tensiones(:,1)+tensiones(:,2))/2;
    B=sqrt( (tensiones(:,1)-tensiones(:,2) ).^2/4 + tensiones(:,3).^2 );
    principales=[ A+B , A-B , tensiones(:,3) ];
    %calcular las tensiones promedio en los nodos.
    sigmax_nod=tennod(nnodo,MC,principales(:,1));
   % sigmay_nod=tennod(nnodo,MC,principales(:,2));
   shear_nod=tennod(nnodo,MC,principales(:,3));
    % Escribir msh base, sobreescribe el generado anteriormente.
    fid=writemsh(NOD,MC,[thiscase,'.msh']);
    nodedatablock([thiscase,'.msh'],nnodo,'"sigma x (Pa,av) " ',1,sigmax_nod);
    nodedatablock([thiscase,'.msh'],nnodo,'"shear (Pa,av) " ',1,shear_nod);
    nodedatablock([thiscase,'.msh'],nnodo,'"Displacement (m) " ',3,[Ux Uy zeros(nnodo,1)] );
    nodedatablock([thiscase,'.msh'],nnodo,'"Forces (m) " ',3,[Fx' Fy' zeros(nnodo,1)] );
end