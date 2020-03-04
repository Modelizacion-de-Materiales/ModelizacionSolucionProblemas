%thismsh='Resortes.msh';
filein='archivo.dat';

[NODOS,ELEM,seccion,modulo,gl,us,fr,r,s]=readata(filein);
nels=size(ELEM,1);
nnod=size(NODOS,1);
% [NOD,MC]=readmsh(filein)
%[seccion,modulo,gl,us,fr,r,s]=mkvin(NOD,MC);
%% Ensamble de la matriz
K=zeros(gl*nnod,gl*nnod);
for i = 1:nels;
    Kelem(:,:,i)=mkel(NODOS(ELEM(i,:),:),gl,modulo(i));
    K=ensamble(ELEM,NODOS,gl,Kelem(:,:,i),K,i);
end
%% Resolución
Fs=fr'-K(r,s)*us';
ur=K(r,r)\Fs;
U(s)=us;
U(r)=ur;
F(s)=K(s,:)*U';

%% Calculo de esfuerzos
for i=1:nels
    locx=( ELEM(i,:) -1)*gl+1;
    Uloc(i,:) = U( locx )
    Floc(i,:) =Kelem(:,:,i)*Uloc(i,:)';
end


close all;
hold on;

factor=10;
plot(NODOS(:,1),NODOS(:,2),'ko-','linewidth',2);
plot(NODOS(:,1)+factor*U',NODOS(:,2),'ro','linewidth',2);
quiver(NODOS(:,1),NODOS(:,2),factor*U',zeros(nnod,1),'Color','r','linewidth',2,'autoscale','off' );
legend('Posiciones Iniciales','Posiciones Finales',['Desplazamientos (x',num2str(factor),')']);
set(gca,'ytick',[]);
ylim([-2,2]);
box on;
saveas(gca,'resultado.pdf','pdf');
% for i=1:nels
%     n=ELEM(i,:);
%     plot(NODOS(n,1),NODOS(n,2),'ko-','linewidth',2);
%     legend('Posiciones Iniciales');
%     plot(NODOS(n,1)+10*U(n)',NODOS(n,2),'ro','linewidth',2);
%     legend('Posiciones Finales');
% end

box on;
ylim([-0.5,0.5]);





%gl=1;
%modulo=[200 200 200];
