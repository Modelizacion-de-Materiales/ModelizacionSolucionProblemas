function Tt=explicito(Ta,Tb,l,tmax,dx,dt,k)
lambda=k*dt/(dx^2);
N=l/dx;
dx=l/(N-1);
disp(['Rounded dx to ',num2str(dx),' to get an integer number on nodes N=',num2str(N)])
To=[Ta,zeros(1,N-2),Tb];
A=zeros(N,N);
A(1,1)=1.0;
for i=2:N-1
    diag=[i-1:i+1];
    A(i,diag)=[-lambda,1.+2.*lambda,-lambda];
end
A(N,N)=1;

Tt(1:N,1)=To;    % a t=0, valen las condiciones iniciales.
t(1)=0;
t(2)=dt;
err(1)=1;
Tt(1:N,2)=A*Tt(1:N,1);

i=1;
while (t(i)<tmax)
    i=i+1;
    t(i)=t(i-1)+dt;
    Tt(1:N,i+1)=A\Tt(1:N,i);
end