%[err,Tred,tmax]=solverdf(dt,N,Ta,Tb,method,tol,freq)
%Esta función resuelve el problema de la barra con extremos a temperatura
%fija con dependencia temporal y condicion inicial de temperatura cero.
%devuelve las temperaturas salvadas cada freqs(2) en Tred y salva gráficos
%cada freqs(1). 

function [err,Tred,t]=solverdf(dt,dx,lambda,N,Ta,Tb,method,tol,freqs)
step2grap=freqs(1)/dt;
step2save=freqs(2)/dt;

x=0:dx:(N-1)*dx;
metname=methodname(method); % tener el nombre en string.
casename=[metname,'lamda',num2str(lambda,'%6.4f')]; % nombre del caso, 

%construye las matrices en un tipo de datos cell 
matrices=matmkr(N,lambda,method);

%inicializo la condición inicial y la guardo en la matriz de salida.
Tred(:,1)=[Ta;zeros(N-2,1);Tb];
Tt(:,1)=Tred; % esta es la temperatura a todo t, que no va a ser guardada.
err(1)=1; % inicialización del error
t(1)=0;   % tiempo inicial
i=1;j=1;k=1; % contadores
plotframe(x,Tt(:,i),casename,[casename,'.gif'],1);

while (err(i)>=tol && err(i)<1000 && i < 500)
    i=i+1; % contador up
    t(i)=t(i-1)+dt; % time forward
    Tt(:,i)=stepsolve(method,Tt(:,i-1),matrices); % solve step
    err(i)=sum( abs( (Tt(:,i)-Tt(:,i-1)) ) );  % nuevo error, este siempre se guarda
    % Hago el gráfico?
%    if mod(i,step2grap)==0 % xor( mod(i,step2grap)==0 && err(i)<=err(i-1) , err(i)>err(i-1) )
           disp(['done at t=',num2str(t(i)),' err = ',num2str(err(i))]);
           j=j+1;
           plotframe(x,Tt(:,i),[metname,...
               ' lambda = ',num2str(lambda,'%6.4f'),...
               ' t = ', num2str(t(i),'%6.4f')],[casename,'.gif'],i);
%    end
    
%    if mod(i,step2save)==0 % xor( mod(i,step2save)==0 && err(i)<err(i-1) , err(i)>err(i-1) )
        k=k+1;
        Tred(:,k)=Tt(:,i);
%    end
    
end