function Kout=ensamble(MCONEC,NODOS,gl,Kelem,Kglob,elem)


[n_el, n_nxel]=size(MCONEC);
[n_n, dim]=size(NODOS);
Kout=Kglob;
nodo=MCONEC(elem,:);
for i=1:n_nxel
    for j=1:n_nxel;
        Kout( (nodo(i)-1)*gl + 1:nodo(i)*gl , (nodo(j)-1)*gl + 1:nodo(j)*gl )=...
            Kout( (nodo(i)-1)*gl+1:nodo(i)*gl , (nodo(j)-1)*gl+1:nodo(j)*gl )+...
            Kelem( (i-1)*gl+1:i*gl , (j-1)*gl+1:j*gl );
    end
end

