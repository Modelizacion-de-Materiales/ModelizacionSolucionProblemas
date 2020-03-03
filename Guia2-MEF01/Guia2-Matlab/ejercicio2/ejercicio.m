
thismsh='archivo.dat';

[NOD,MC,seccion,modulo,gl,us,fr,r,s]=readata(thismsh);
K = mkrig(2,gl,NOD,MC,modulo,seccion);

nnodo=size(NOD,1);
[nels nnxel]=size(MC);

%%
Kred=K(r,r);
ur=Kred\fr';
ngl=size(NOD,1)*gl;
%%
U=zeros(ngl,1);
U(r)=ur;
U(s)=us;
F(r)=fr;
F(s)=K(s,:)*U;
%%
hold on;
fx=1000;  %% escalas para graficar las fuerzas
fy=100;
Ux=U(1:gl:ngl);
Uy=U(2:gl:ngl);
Fx=F(1:gl:ngl);
Fy=F(2:gl:ngl);

close all
hold all
box on

% me falta sacar las tensiones. 

%%
for el=1:nels
    nod=MC(el,:);
    for nn=1:nnxel
        Uloc(nn,:)=U( (nod(nn)-1)*gl+1:nod(nn)*gl );
    end
    L=norm( NOD(nod(2),:)-NOD(nod(1),:) );
    dir=NOD(nod(2),:) - NOD(nod(1),:);
    ldir=dir/norm(dir);
    DU(el,:)=diff(Uloc,1);
    eps(el) =  DU(el,:) * ldir'  / L;
    sigma(el)=modulo(el)*eps(el);
end
    
%%    
for i=1:nels
    n=MC(i,:);
    plot(NOD(n,1),NOD(n,2),'ko-','linewidth',2);
    plot(NOD(n,1)+fx*Ux(n),NOD(n,2)+fy*Uy(n),'ro-','linewidth',2);
end
%%
quiver(NOD(:,1),NOD(:,2),fx*Ux,fy*Uy,'Color','b','linewidth',2,'autoscale','off');
quiver(NOD(:,1)+fx*Ux,NOD(:,2)+fy*Uy,1e-4*Fx',1e-4*Fy','Color','k','linewidth',2,'autoscale','off');
saveas(gcf,'resultado.pdf','pdf');

fid=fopen('resultados.dat','w');
fprintf(fid,'\n Resultados por nodo \n');
fprintf(fid,'# n X Y Ux Uy Fx Fy \n');

for i=1:nnodo
    fprintf(fid,'%d  %4.2f  %4.2f  %6.4e  %6.4e  %6.4e  %6.4e \n',...
        i,  NOD(i,1), NOD(i,2), Ux(i), Uy(i), Fx(i), Fy(i) );
end

fprintf(fid,'\n Resultados por elemento \n');
fprintf(fid,'# n nodo2  nodo 2 sigma \n');
for i = 1:nels
    fprintf( fid,'%d   %d   %d   %6.4e  \n',i,MC(i,1), MC(i,2), sigma(i) );
end

fclose(fid);


%% Guardo un msh para ver en gmsh con los resultados.
fileout='puente-out.msh';
writemsh(NOD,MC,fileout);
nodedatablock(fileout,nnodo,0,0.0,'"Desplazamientos (m)"',3,[Ux,Uy,zeros(nnodo,1)]);
nodedatablock(fileout,nnodo,0,0.0,'"Fuerzas (N)"',3,[Fx',Fy',zeros(nnodo,1)]);
elementdatablock(fileout,nels,0,0.0,'"Tensiones (Pa)"',1,sigma');
    