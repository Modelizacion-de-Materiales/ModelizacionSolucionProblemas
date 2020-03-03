function I=integra(fun,puntos,pesos)
n=length(puntos);
I=0;
for i=1:n
    I=I+pesos(i)*feval(fun,puntos(i));
end