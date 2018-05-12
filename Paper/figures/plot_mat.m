
cd('C:\Users\User\Desktop\gal\Technion\EEG_Project\Paper\figures\example_rotation_8_subj');

%% Riemannian Geometry
load data.mat;
title_str = [];

%% PT
load data_PT.mat;
title_str = 'with PT';

%% Rotation
load data_rot.mat;
title_str = 'with PT and rotation';

%%
% load labels.mat;
ax = [];
subj_names = {'C01';'C02';'C03';'C04';'C05';'C06';'C07';'C08';'C10';'C11';'C12';'S01';'S02';'S03';'S04';'S05'};
color_list = {[0 1 1];[1 0 1];[0 1 0]}; % for 3 stimulations

figure(); hold on; ax(1) = gca;
num_sub = unique(full_label_struct{2});
for ii = 1 : length(num_sub)
    idx = find(full_label_struct{2} == num_sub(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),50,full_label_struct{2}(idx), 'Marker','x','LineWidth',1.5);  
end
subj_str = subj_names(num_sub);
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(subj_str(:), 'Interpreter', 'latex', 'location','best');
title(sprintf('PCA map, colored per subject %s', title_str),'interpreter','latex');
% view(-89.46,11.92);

figure(); hold on; ax(2) = gca;
num_stim = unique(full_label_struct{3});
for ii = 1 : length(num_stim)
    idx = find(full_label_struct{3} == num_stim(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),30,'MarkerFaceColor',color_list{ii},'MarkerEdgeColor','none'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(full_label_struct{4}(:), 'Interpreter', 'none', 'location', 'best');
title(sprintf('PCA map, colored per stimulus %s', title_str),'interpreter','latex');
% view(-89.46,11.92);

linkprop(ax,{'CameraPosition','CameraUpVector'}); 