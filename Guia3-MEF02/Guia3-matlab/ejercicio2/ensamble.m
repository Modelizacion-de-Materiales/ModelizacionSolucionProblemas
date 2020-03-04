function K=ensamble(MCONEC,NODOS,gl,varargin)


modulo=varargin{1};
pois=varargin{2};
esp=varargin{3};

[n_el, n_nxel]=size(MCONEC);
[n_n, dim]=size(NODOS);
K=zeros(n_n*gl);
fid=fopen('matrices.dat','w');
fid2=fopen('matsB.dat','w');
fclose(fid2);
fmt=[];
% for i=1:gl*n_n; fmt=[fmt,' %6.4e']; end
%fmt=['%6.4 \n'];
for el=1:n_el
%     disp(['Ensamblando elemento ',num2str(el)]);
    nodo=MCONEC(el,:);
    kel=mkel(NODOS(nodo,:),gl,modulo,pois,esp,el);
    for i=1:n_nxel
        for j=1:n_nxel;
            for p=1:gl
                for q=1:gl;
    K( (nodo(i)-1)*gl + p , (nodo(j)-1)*gl + q )=...
    K( (nodo(i)-1)*gl + p , (nodo(j)-1)*gl + q ) + ...
    kel( (i-1)*gl+p , (j-1)*gl+q );
                end
            end
        end
        fmt=[fmt,' %6.4f '];
    end
    
%     fid=fopen('matrices.dat','a');
%     fprintf(fid,'\n Ensamblaje del elemento %d \n',el);
%     for i=1:gl*n_n ; fprintf(fid,fmt,K(i,:) ); end
%     fclose(fid);
end

