% function K=ensamble2(ELEM,NODO,gl,kel,kglobal)
% Función para ensamblar una matriz elemental en la matriz global. 
%
% ELEM: Matriz de conectividad del elemento actual (nodos que acopla)
% NODO: matriz de cordenada de los nodos de la matriz actual.
% gl : grados de libertad por nodo.
% kel :  matriz local
% kglobal: estado anterior de la matriz global


function K=ensamble2(ELEM,NODO,gl,kel,kglobal)

% recupero la dimensionalidad del sistema.
[n_el, n_nxel]=size(ELEM); % numero de elementos, nodos por elemento
[n_n, dim]=size(NODO);     % numero de nodos, dimensionalidad.
K=kglobal;                 % matriz global en su estado anterior.

for i=1:n_nxel     % recorro todos los nodos del elemento
   for j=1:n_nxel; % se combinan todos con todos.
       
       % y copio cada bloque de la matriz elemental en la matriz global:
       K( (ELEM(i)-1)*gl+1:ELEM(i)*gl ,(ELEM(j)-1)*gl+1:ELEM(j)*gl)=...
               K( (ELEM(i)-1)*gl+1:ELEM(i)*gl ,(ELEM(j)-1)*gl+1:ELEM(j)*gl)+...
               kel( (i-1)*gl+1:i*gl , (j-1)*gl+1:j*gl);
   end
end

