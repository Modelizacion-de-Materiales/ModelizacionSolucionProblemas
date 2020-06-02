% Esta función ensambla la matriz elemental 
function K=ensamble(MCONEC,NODOS,Kin,kel,gl,varargin)

n_nxel=length(MCONEC);
[n_n, dim]=size(NODOS);
K=Kin;
for i=1:n_nxel
    for j=1:n_nxel;
        n=MCONEC(i);
        m=MCONEC(j);
        K( (n-1)*gl+1:n*gl, (m-1)*gl+1:m*gl )=...
            K( (n-1)*gl+1:n*gl, (m-1)*gl+1:m*gl )+...
            kel( (i-1)*gl+1:i*gl, (j-1)*gl+1:j*gl );
    end
end
