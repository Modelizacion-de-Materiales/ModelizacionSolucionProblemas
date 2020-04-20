long=1.50; %m
A=0.001; %seccion, metros ^2
E=210e9; %Modulo elástico, Pa
C=-2000; %N/m;

despteo=@(x) (x.^3-long^3)*5./(A*E);
sigmteo=@(x) 5*x.^3./A;

close all
box on
hold all
for N=1:6 %barro en número de elementos

  [U,F,frame,R(N)]=loop(long,A,E,C,N+1);
  D(N)=U(1);

end

saveas(gcf,'resultado3.pdf','pdf');
