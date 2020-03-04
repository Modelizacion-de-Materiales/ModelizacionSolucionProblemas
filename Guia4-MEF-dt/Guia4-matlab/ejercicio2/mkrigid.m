function K=mkrigid(MC,NODOS,gl,varargin)

nnod = size(NODOS,1);
[ nel nnxel ] = size(MC);

E=varargin{1};
if nargin > 4
    A=varargin{2};
    L=1;
elseif nargin>5
    A=varargin{2};
    L=varargin{3};
else
    A=1;
    L=1;
end

K=zeros(nnod*gl);
for i=1:nel
    thisel=MC(i,:);
    nodlocal=NODOS(thisel,:);
    kel=mkel(nodlocal,gl,E,A,i);
    K=ensamble(thisel,nodlocal,K,kel,gl);
end