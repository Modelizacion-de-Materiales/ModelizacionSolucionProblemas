% function kloc=mklocs(type,MC,NOD,gl,el,{modulos,seccion})
% Función para definir la matriz local, en los casos derivados de barras.
% type   =1 : resortes, debe agregar modulo (k)
%        =2 : barras, debe agregar modulo y sección (E, A)
%        =3 : barras a flección, debe agregar modulo, momento de inercia,
%        =4 : triangulos lineales
%        seccion (E, I, A)
%
% MC: Matriz de Conectividad (local).
% NOD: Nodos (local)
% gl: grados de libertad.
% el: elemento actual


function kloc=mklocs(type,MC,NOD,gl,el,varargin)

[n_el, n_nxel]=size(MC);
[n_n, dim]=size(NOD);

if gl == 1
    kl = [1 -1 ; -1 1];
elseif gl == 2
    kl = [ 1 0 -1 0 ; 0 0 0 0 ; -1 0 1 0 ; 0 0 0 0 ];
end


if type == 1  %% armar matrices para resortes.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    modulo=varargin{1};
    kloc= modulo*kl;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif type == 2 %% armar matrices para barras a tracción, orientación cualquiera.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for nod=1:n_nxel
        n(nod)=MC(nod);
        r(nod,:)=NOD(nod,:);
    end
    [L,R]=geom(r(1,:), r(2,:)) ;
    T=[R , zeros(2) ; zeros(2), R];
    
    modulo = varargin{1};
    seccion = varargin{2};
    kl=(modulo*seccion/L)*kl;
    kloc=T'*kl*T;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif type == 3    %% elementos para barras en flección (solo con 2 grados de libertad)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for nod=1:n_nxel
        n(nod)=MC(nod);
        r(nod,:)=NODOS(nod,:);
    end
    
    [L,R]=geom(r(1,:), r(2,:)) ;
    
    modulo = varargin{1};
    inercia = varargin{2};
    seccion = varargin{3};
    
    kloc = ( modulo * inercia / L^3 )*[ 12 6*L -12 6*L ;...
        6*L 4*L^2 -6*L 2*L^2 ; ...
        -12 -6*L 12 - 6*L ; ...
        6*L 2*L^2 -6*L 4*L^2 ];

    
%%% triangulos lineales
elseif type == 4
    % tomo variables auxiliares:
    modulo=varargin{1};
    pois=varargin{2};
    espe=varargin{3};

    [nnxel dim]=size(NOD);
    
    X=NOD(:,1); Y=NOD(:,2);
    if dim==2 ; Z=zeros(nnxel,1);elseif dim==3 ; Z=nodlocal(:,3); end
    %alfa
    ai=X(2)*Y(3)-Y(2)*X(3); aj=X(1)*Y(3)-Y(1)*X(3);am=X(1)*Y(2)-Y(1)*X(2);
    %beta
    bi=Y(2)-Y(3);bj=Y(3)-Y(1);bm=Y(1)-Y(2);
    %gama
    gi=X(3)-X(2);gj=X(1)-X(3);gm=X(2)-X(1);
    % Area con signo
    A=0.5*det([ones(3,1) X Y] );
    % matriz B, finalmente:
    B=[ bi 0 bj 0 bm 0 ; 0 gi 0 gj 0 gm ; gi bi gj bj gm bm ]/(2*A);
    % Matriz de elasticidad tensiones planas
    D = [ 1 pois 0 ; pois 1 0 ; 0 0 0.5*(1-pois) ]*modulo/(1-pois^2);
    %area:
    seccion=abs(A);
    %matriz local
    kloc= espe*seccion*B'*(D*B);
end

for i=1:size(kloc,1);
    for j =1:size(kloc,2);
        if abs(kloc(i,j)) < 1e-6;
            kloc(i,j)=0;
        end
    end
end

kloc;

end


function [long, rot]=geom(r1,r2)
    
    theta=atan2( r2(2)-r1(2),r2(1)-r1(1) );
    long=norm(r2-r1);
    rot=[ cos(theta)  sin(theta) ; -sin(theta)  cos(theta) ];

end
