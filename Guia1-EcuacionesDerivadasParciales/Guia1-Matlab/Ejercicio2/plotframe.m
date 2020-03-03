function plotframe(X,Y,titulo,moviename,frame)
fig1=figure(1);
set(fig1,'nextplot','replacechildren');
% set(fig1,'Visible','off');
%winzize=get(fig1,'position');
plot(X,Y,'ko-','Linewidth',2)
ylim([0 100]);
title(titulo);
xlabel('X (cm)','Fontsize',10);
ylabel('T (C)','Fontsize',10);
M=getframe(fig1);
im = frame2im(M);
[imind,cm] = rgb2ind(im,256);
if frame==1
    imwrite(imind,cm,moviename,'gif','WriteMode','overwrite','LoopCount',Inf,'delaytime',0.1);
else
    imwrite(imind,cm,moviename,'gif','WriteMode','append','delaytime',0.1);
end
    
