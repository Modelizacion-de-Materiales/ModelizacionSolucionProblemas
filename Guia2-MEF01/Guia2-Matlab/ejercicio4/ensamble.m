function K=ensamble(MCONEC,NODOS,gl,varargin)

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

fname=['matrices_',num2str(n_n),'.dat'];
fid=fopen(fname,'w');
fprintf(fid,'\n %d Elementos \n \n',n_el);
fclose(fid);

for el=1:n_el
    nodo=MCONEC(el,:);
    kel=mkel(NODOS(nodo,:),gl,propiedades{1}(el),propiedades{2}(el),el,fname);
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
    end
end

fid=fopen(fname,'a');
fprintf(fid,'\n Matriz Global \n',n_el);
fclose(fid);
dlmwrite(fname,K,'-append','delimiter','\t','precision','%6.4e');

