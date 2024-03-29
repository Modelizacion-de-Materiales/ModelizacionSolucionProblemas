%% Inicializar variables generales
gl=2; %grados de libertad.
E=210e9; %Pa
L=1; %m de longitud
A=10e-4; %m^2, área.
rho=7850; % densidad kg m^-3;
%%I=10*(1e-2)^4;
I=10*(1e-8);
tol = 1e-3;
err=ones(1,4);
N=1;
step=0;
j=1;
title1='===========\nmatriz de rigidez\n'
title2='===========\nmasas consistentes\n'
title3='===========\nmasas reducidas\n'
%for N=1:20;   % Número de elementos.
%while (sum( err(j,:) > tol ) ~= 0)&&j<2
    while j < 8
    %% loop
    step=step+1;
    N=fix( N*(10^0.1) )+1; % ten points per decade logaritmic scale.
    thiscase=['N',num2str(N,'%d')];
    % Esta vez hago el .geo en función del número de elementos y la
    % longitud de la barra.
    writegeo(L,N,[thiscase,'.geo']);  % hacer la geometría
    system(['gmsh -1 -format msh22 ',thiscase,'.geo ',thiscase,'.msh']); %hacer el msh
    %% Leer el msh creado
    [NOD,MC]=readmsh([thiscase,'.msh'],1);  % obtener nodos y matriz de conectividad, solo para líneas.
    ngl=size(NOD,1)*gl;   % numero totales de grados de libertad.
    nnodo=size(NOD,1);   % número de nodos total
    [nels nnxel]=size(MC);  % número de elementos, numero de nodos por elemento
    modulos=E*ones(nels,1);
    inercias=I*ones(nels,1);
    secciones=A*ones(nels,1);
    densidades=rho*ones(nels,1);
    fo = fopen([thiscase,'.dat'])
    fmtspec = [];
    for i =1:N
      fmtspec = [fmtspec, '%10.4e %10.4e']
    end
    fmtspec = [fmtspec,'\n']
    %% resolución
    % El único Vínculo es que se debe empotrar el borde derecho!
    [us,fr,r,s]=mkvin(NOD,MC,gl); % hacer vínculos.
    K=mkrig(3,gl,NOD,MC,modulos,secciones,inercias); %Hacer matríz de rigidez.
    %% Matrices de masa
    fprintf(fo, title1)
    % dlmwrite([thiscase,'.dat'], K, '-append', 'delimiter','\t', 'precision', 3)
    fprintf(fo, fmtspec, K)
    fclose(fo)

    Mente=mkmasg(3,gl,NOD,MC,densidades,secciones); %hacer matriz de masas consistentes.
    %dlmwrite([thiscase,'.dat'], title2, '-append', 'delimiter','' )
    %dlmwrite([thiscase,'.dat'], Mente, '-append' , 'delimiter','\t', 'precision', 3 )
    Mida=mkmasg(4,gl,NOD,MC,densidades,secciones); % hmkmasa(gl,2,NOD,MC,rho,A,L);acer matriz de masas reducida.
    %dlmwrite([thiscase,'.dat'], title3, '-append', 'delimiter','' )
    %dlmwrite([thiscase,'.dat'], Mida, '-append' , 'delimiter','\t', 'precision', 3 )
    %% Resolución 
    %  [K  - w**2 M] U  = 0
    [Dente,W2ente]=eig(K(r,r),Mente(r,r));
    [Dida,W2ida]=eig(K(r,r),Mida(r,r));
    %% Guardo los resultados para graficar
    wente{step}=sqrt(diag(W2ente))/(2*pi);
    wida{step}=sqrt(diag(W2ida))/(2*pi);
    j=j+1;
%    delete([thiscase,'.*'])
end
%%
%D=[zeros(1,N);D]; %Debo agregar el nodo vinculado
Uente=zeros(nnodo*gl,nnodo*gl-length(s));
Uida=zeros(nnodo*gl,nnodo*gl-length(s));
for i=1:size(Dente,2)
    Uente(s,i)=us;Uida(s,i)=us;
    Uente(r,i)=Dente(:,i);Uida(r,i)=Dida(:,i);
end


plotmodes(wente,Uente,nnodo,gl,L,'Consistentes');
plotmodes(wida,Uida,nnodo,gl,L,'Reducidas');
%% postprocessing
compara(wente, wida, 2, 'consistente','reducida')



