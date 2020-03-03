%function name=methodname(method)
% Esta función da el nombre del método a usar como función de 
% el número de método en la estructura del programa.

function name=methodname(method)
if method==1
    name='Explicito';
elseif method==2
    name='Implicito';
elseif method==3
    name='Crank-Nicholson';
end
