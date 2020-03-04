long=6; %m
I=2e-4; %seccion, metros ^2
E=210e9; %Modulo elástico, Pa
k=200e3; %N/m;
hold all

close all
hold all
box on
for N=3:2:9 %barro en número de nodos

[U,F]=loop(long,I,E,k,N);

end

saveas(gcf,'resultado4.pdf','pdf');