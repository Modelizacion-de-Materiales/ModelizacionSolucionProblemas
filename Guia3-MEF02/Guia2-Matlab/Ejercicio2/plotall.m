%plotall(casename,x,y,texti)
% plots all columns of matrix y as a function of vector x, with titles
% texti. casename is set to the title of the graph, which is saved to
% casename.pdf.

function plotall(casename,x,y,texti)
close all
plot(x,y(:,1),'linewidth',2);
titul=['t =',num2str(texti(1),'%4.2f')];
hold all
%%
for i=2:size(y,2)
    plot(x,y(:,i),'linewidth',2);
    titul=[titul;'t=',num2str(texti(i),'%4.2f')];
end
legend(titul,'Location','EastOutside');
title(casename);
saveas(gcf,[casename,'.pdf'],'pdf');