function plotmodes(w,V,nnod,gl,L,casename)
total_steps=size(w,2);
wa=zeros(total_steps,5);

for i=1:total_steps
    nnodi=length(w{i}(1:gl:end));
    h=min([4,i]);
    wa(i,1:h+1)=[nnodi,w{i}(1:h)'];
end
%%
close all;
%%

subplot(2,1,1);
title(['Masas ,',casename]);
hold all;
box on;
xlabel('Numero de nodos');
ylabel('frecuencia (Hz)');

for i=1:4
    plot( wa(i:total_steps,1) ,wa(i:total_steps,i+1),'o-' );
    if i == 1
        elabel=['modo ',num2str(i)];
    else
        elabel=cat(1,elabel,['modo ',num2str(i)]);
    end
end
legend(elabel);
subplot(2,1,2);
hold all;
box on
xlabel('X (m)');
ylabel('Desplazamiento transversal');
x=0:L/(nnod-1):L;
for i=1:4
    Y=V(1:gl:end,i)/V(end-1,i);
    plot(x,Y);
end
legend(elabel)
saveas(gcf,['modes',casename,'.pdf'],'pdf');

end
