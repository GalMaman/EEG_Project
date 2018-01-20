load 'electrodes_location.mat';

%%
idx       = [];
for ii = 1 : length(elec_array)
    idx = [idx; find(elec_array(ii) == electrodes_location(:,1))];
end
figure(); hold on; ax = gca;
scatter3(electrodes_location(:,3),electrodes_location(:,4),electrodes_location(:,5),'filled');
plot3(electrodes_location(idx,3),electrodes_location(idx,4),electrodes_location(idx,5),'mo', 'Linewidth',2);
str = string(electrodes_location(idx,1));
textscatter3(electrodes_location(idx,3)+0.05,electrodes_location(idx,4)+0.05,...
    electrodes_location(idx,5)+0.05,str,'TextDensityPercentage',90)
legend([{'electrodes location'}; {'electrodes used'}], 'interpreter','latex');
xlabel('x','interpreter','latex');
ylabel('y','interpreter','latex');
zlabel('z','interpreter','latex');
title('EEG Electrode Cap','interpreter','latex');
set(ax,'FontSize',12)

%%
type     = electrodes_location(:,2);
type_num = [1,2,3,4];
leg_str  = [{'Somatosensory'}; {'Auditory Tones'}; {'Auditory Complex'}; {'Visual'}];
figure(); ax = gca; hold on;
for jj = 1 : length(type_num)
    idx = find(type == type_num(jj));
    scatter3(electrodes_location(idx,3),electrodes_location(idx,4),electrodes_location(idx,5),50, electrodes_location(idx,2), 'Fill');
end
str = string(electrodes_location(:,1));
textscatter3(electrodes_location(:,3)+0.05,electrodes_location(:,4)+0.05,...
    electrodes_location(:,5)+0.05,str,'TextDensityPercentage',90)
legend(leg_str, 'interpreter','latex');
xlabel('x','interpreter','latex');
ylabel('y','interpreter','latex');
zlabel('z','interpreter','latex');
title('EEG Electrode Cap colord according to stimulus type','interpreter','latex');
set(ax,'FontSize',12)
