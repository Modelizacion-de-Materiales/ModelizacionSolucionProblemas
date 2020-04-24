% F=@(z) (z./(5+z)) * exp(-2*z /30 ) ;
clear all
F=@(t) (2/sqrt(pi))*exp(-t.^2);
L=@(m,c,te) m*te+c;
%%
a=0; b=4;
m=(b-a)/2; c=(a+b)/2;
%%
err=0
for i=1:4
    clear X W;
    [X,W]=puntos_pesos(i);
    I(i)=m*F(L(m,c,X))*W';
    err(i)=abs( (I(i) - erf(b))/erf(b));
end

plot([1:4],err,'Color','k','linewidth',2)

% I=integra(F,L(m,c,X),W)
%%
