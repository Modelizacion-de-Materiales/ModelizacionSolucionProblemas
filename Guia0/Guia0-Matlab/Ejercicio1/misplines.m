% Esta función calcula la interpolación por splines naturales a los datos
% x,y. La estrategia es resolver el sistema de ecuaciones:
% h_i S_i+1 + 2(h_i-1 + h_i-1 ) S_i + h_i-1 S_i-1 = 
% = 6 [ (y_i+1 - y_i )/h_i - (y_i - y_i-1)/h_i-1 ]

function [P,XY]=misplines(x,y,suffix)
%%ninicializo variables

n=length(x);
h=zeros(1,n-1);        %incrementos
B=zeros(n,1);        % vector de resultados
A=zeros(n,n);        % matriz
a=zeros(n-1,1);%%%%%%%%
b=zeros(n,1);       % Coeficientes de los polinomios
c=zeros(n-1,1);%%%%%%%% f_i(x) = a_i x^3 + b_i x^2 + c_i x + y_i
d=y; % los valores de las variables independientes ya los conozco.

%% primero armo la matriz
% voy a necesitar todos los hi

h(1)=x(2)-x(1);
B(1)=0;
A(1,1)=1.0;
for i=2:n-1
    h(i)=x(i+1)-x(i);
    B(i)=3.*((y(i+1)-y(i))/h(i) - (y(i)-y(i-1))/h(i-1));
    A(i,[i-1:i+1]) = [h(i-1) , 2.*(h(i)+h(i-1)) , h(i)];
end
B(n)=0;
A(n,n)=1.0;

filename=['matrizA',suffix];
save(filename,'A','-ascii');
filename=['results',suffix];
save('results.dat','B','-ascii');
        
% finalmente con la matriz armada resuelvo el sistema para las b

b=A\B;

% y ahora me faltan los otros coeficientes

i=0;

for i=1:n-1  
    a(i)=(b(i+1)-b(i))/(3.*h(i));                            % A medida que voy calculando coefs
    c(i)=(y(i+1) - y(i))/h(i) - b(i)*h(i) - a(i)*h(i)^2;     % voy graficando los polinomios
end

filename=['valores_a',suffix];
save(filename,'a','-ascii');
filename=['valores_b',suffix];
save(filename,'b','-ascii');
filename=['valores_c',suffix];
save(filename,'c','-ascii');


% me falta armar la matriz de polinomios.
P=[a,b(1:n-1),c,d(1:n-1)];
dP=[3*a,2*b(1:n-1),c];
ddP=[6*a,2*b(1:n-1)];
% y ahora me voy a armar una lista de valores para hacer el gráfico.

% cantidad de puntos por intervalo:
N=100;
XY=zeros(N*(n-1),4);
for i = 1:n-1
    m=N*(i-1)+1:N*i;
    XY( m , 1 )=linspace(x(i),x(i+1),N);
    XY( m , 2 )=polyval(P(i,:),XY( m , 1 )-x(i));
    XY( m , 3 )=polyval(dP(i,:),XY( m , 1)-x(i)) ;
    XY( m , 4 )=polyval(ddP(i,:),XY( m , 1)-x(i)) ;
end

