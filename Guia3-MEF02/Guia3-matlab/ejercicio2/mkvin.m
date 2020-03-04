function [us,fr,r,s]=mkvin(NODOS,MC,gl,varargin)
gl=2;
[ nnod dim ]=size(NODOS);
[nels,nnxel]=size(MC);
esp=varargin{1};
T=varargin{2};
if (nargin-3)>4
    bi=varargin{3};
    bd=varargin{4};
    bsup=varargin{5};
    binf=varargin{6}
elseif (nargin-3)>2
    bi=varargin{3};
    bd=varargin{4};
    bsup=5;    binf=-5;
elseif (nargin-3)==2
    bi=-10; bd=10; bsup=5; binf=-5;
end
ejex=(bd+bi)/2;
ejey=(bsup+binf)/2;    

r=[];
s=[];
us=[];
fr=[];
f=zeros(gl*nnod,1);
tol=1e-3;


%fuerza distribuida
% ?

for i=1:nels
    brdde=sum( abs(NODOS(MC(i,:))-bd)<=tol );  %borders
    brdiz=sum( abs(NODOS(MC(i,:))-bi)<=tol );  %borders
    if brdde==2
        n=[];
        for j=1:nnxel
            if ( abs( NODOS(MC(i,j))-bd )<=tol )
                n=[n,MC(i,j)];
            end
        end
        l=abs( diff( NODOS(n,2) ));
        f(gl*(n-1)+1)=f(gl*(n-1)+1)+0.5*esp*l*T;
    elseif brdiz==2
        n=[];
        for j=1:nnxel
            if ( abs( NODOS(MC(i,j))-bi )<=tol )
                n=[n,MC(i,j)];
            end
        end
        l=abs( diff( NODOS(n,2) ));
        f(gl*(n-1)+1)=f(gl*(n-1)+1)-0.5*esp*l*T;
    end    
end


for i=1:nnod
    % # Primero tengo que ver los nodos que no estan acoplados a ningun
    % nodo y vincular sus dos grados de libertad.
    if ( sum( sum(MC==i) ) == 0 )
        % si este nodo no esta en ningun elemento, entonces lo trato como
        % nodo vinculado
        s=[s,gl*(i-1)+1:gl*i];
        us=[us; zeros(gl,1)];
    elseif (abs(NODOS(i,1)-ejex)<tol) % Los del eje y no se pueden desplazar en x
        s=[s,gl*(i-1)+1];
        r=[r,gl*i];
        us=[us;0.0];
    elseif ( abs(NODOS(i,2)- ejey)<tol ); %Los del eje x no se pueden desplazar en y
        s=[s,gl*i];
        r=[r,gl*(i-1)+1];
        us=[us; 0.0 ];
    else
        r=[r,gl*(i-1)+1:gl*i];
    end
end

fr=f(r);
    