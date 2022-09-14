function SaveFluorStats(C,filename,path,resolu)
% M = reshape(cat(2,C{:}),[512,512,numel(C)]);
M = C;
F=zeros([size(M,3) 4]);
Ftext = {'min'; 'max'; 'mean'; 'median'};

for i = 1:size(M,3)
    m = M(:,:,i);
    m = m(:);
    F(i,:) = [min(m) max(m) mean(m) median(m)];
end
%%
figure(1);
ax = axes;


plot(ax, F(:,[1 2]), '-', 'LineWidth', 0.8);
hold on;
plot(ax, F(:,[3 4]), '--', 'LineWidth', 1.3);
set(gca, 'box', 'off', 'GridLineStyle', ':', 'YGrid', 'on');
ax.YAxis.Exponent = 0;
ax.ColorOrder = [1 .0 .0; .0 .6 .0; .3 .3 .9;.1 .1 .1];
title(filename,'Interpreter','none');
legend(Ftext([1 2 3 4]));
fig = gcf;

idx = strfind (filename, '.ti');
output = strcat (filename(1:idx-1),'.png');
outputfile = strcat (path, output);
exportgraphics(fig,outputfile,'Resolution',resolu);
close(figure(1));
% Elapsed time is 0.531604 seconds.
end 
