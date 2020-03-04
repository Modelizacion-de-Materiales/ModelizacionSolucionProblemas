function K=mkrigid(MC,NODOS,gl,varargin)

nnod = size(NODOS,1);
[ nel nnxel ] = size(MC);

E=varargin{1};
nu=varargin{2};
esp=varargin{3};
K=zeros(nnod*gl);

for i=1:nel
    thisel=MC(i,:);
    nodlocal=NODOS(thisel,:);
    kel=mkel(nodlocal,gl,E,nu,esp,i);
    K=ensamble(thisel,nodlocal,K,kel,gl);
end