function compara(w1, w2, gl, label1, label2)

total_steps=[size(w1,2), size(w2,2)];
wa=zeros(total_steps(1),5);
wb=zeros(total_steps(2),5);

for i=1:total_steps(1)
    nnodi=length(w1{i}(1:gl:end));
    h=min([4,i]);
    wa(i,1:h+1)=[nnodi,w1{i}(1:h)'];
end
for i=1:total_steps(2)
    nnodi=length(w2{i}(1:gl:end));
    h=min([4,i]);
    wb(i,1:h+1)=[nnodi,w2{i}(1:h)'];
end
figure()
hold on
for i=1:4
    plot( wa(i:total_steps,1) ,wa(i:total_steps,i+1),'o-k' );
    plot( wb(i:total_steps,1) ,wb(i:total_steps,i+1),'o-r' );
    if i == 1
        elabel=['modo ',num2str(i)];
    else
        elabel=cat(1,elabel,['modo ',num2str(i)]);
    end
end
legend(label1, label2)
