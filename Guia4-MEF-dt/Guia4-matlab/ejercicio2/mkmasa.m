
function M=mkmasa(gl,caso,NODOS,MC,varargin)

nnod=size(NODOS,1);
[ nel nnxel ] = size(MC);
M=zeros(nnod*gl);
rho=varargin{1};
if nargin == 6
    A=varargin{2};
    L=1;
elseif nargin==7
    A=varargin{2};
    L=varargin{3};
else
    A=1;
    L=1;
end
    
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
    end
    M=ensamble(thisel,nodlocal,M,Mloc,gl);
end