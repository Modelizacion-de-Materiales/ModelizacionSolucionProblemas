long=30*12; %in, 1 ft = 12 in
I=200; %momento de inercia, in^4
E=29e6; %Modulo elástico, psi
C=-2000/12; %lb/in;

close all
hold all
box on
for N=2:7 %barro en número de nodos;
[U,F,frame]=loop(long,I,E,C,N);
end

saveas(gcf,'resultado5.pdf','pdf');
