function [K,kel]=ensamble(MCONEC,NODOS,gl,varargin)

if nargin == 4
    modulo=varargin{1};
elseif nargin==5
    modulo=varargin{1};
    secciones=varargin{2};
end
propiedades=varargin(:);
[n_el, n_nxel]=size(MCONEC);
[n_n, dim]=size(NODOS);
K=zeros(n_n*gl);
kel=zeros(n_nxel*gl,n_nxel*gl,n_el);
fid=fopen('matrices.dat','w');
fclose(fid);
fmt=[];
for i=1:gl*n_n; fmt=[fmt,' %6.4e']; end
fmt=[fmt,' \n'];
for el=1:n_el
    nodo=MCONEC(el,:);
    kel(:,:,el)=mkel(NODOS(nodo,:),gl,propiedades{1}(el),propiedades{2}(el),el);
    for i=1:n_nxel
        for j=1:n_nxel;
           K( (nodo(i)-1)*gl+1:nodo(i)*gl ,(nodo(j)-1)*gl+1:nodo(j)*gl)=...
               K( (nodo(i)-1)*gl+1:nodo(i)*gl ,(nodo(j)-1)*gl+1:nodo(j)*gl)+...
               kel( (i-1)*gl+1:i*gl , (j-1)*gl+1:j*gl , el);
            end
        end
        fmt=[fmt,' %6.4f '];
    end
    
    fid=fopen('matrices.dat','a');
    fprintf(fid,'\n Ensamblaje del elemento %d \n',el);
    for i=1:gl*n_n ; fprintf(fid,fmt,K(i,:) ); end
    fclose(fid);    
end

