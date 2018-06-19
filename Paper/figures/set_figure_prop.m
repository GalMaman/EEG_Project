function [] = set_figure_prop()

% set axes system

xL = xlim;
yL = ylim;
line(xL, [0 0],'color','k','linewidth',0.1); 
line([0 0], yL,'color','k','linewidth',0.1); 
h = findobj(gca,'Type','line');
set(h, 'HandleVisibility','off');
% remuve values from axes
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
% align grid
x_space   = (-min(xL)/4);
y_space   = (-min(yL)/4);
x_tickVal = [fliplr(0-x_space:-x_space:min(xL)) 0:x_space:max(xL)];
y_tickVal = [fliplr(0-y_space:-y_space:min(yL)) 0:y_space:max(yL)];
set(gca,'XTick',x_tickVal);
set(gca,'YTick',y_tickVal);
