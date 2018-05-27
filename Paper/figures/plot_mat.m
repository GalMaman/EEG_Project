% 
% cd('C:\Users\User\Desktop\gal\Technion\EEG_Project\Paper\figures\example_rotation_8_subj');
% 
% %% Riemannian Geometry
% load data.mat;
% title_str = [];
% 
% %% PT
% load data_PT.mat;
% title_str = 'with PT';
% 
% %% Rotation
% load data_rot.mat;
% title_str = 'with PT and rotation';

%%
close all
clear

%%
RiemannianGeometry    = 1;
PtGeometry            = 2;
PtAndRotationGeometry = 3;

subject      = 2;
GeometryCase = PtGeometry;

dirPath = ['./example_rotation_', num2str(subject), '_subj/'];
switch (GeometryCase)
    case RiemannianGeometry
        fileName  = 'Riemannian_Geometry/data.mat';
        title_str = 'Riemannian_Geometry';
        vAxis     = [-8, 8, -6, 6, -2, 2];
    case PtGeometry
        fileName  = 'PT/data_PT.mat';
        title_str = 'PT';
        vAxis     = [-10, 10, -5, 5, -2, 2];
    case PtAndRotationGeometry
        fileName  = 'PT_and_rotation/data_rot.mat';
        title_str = 'PT and rotation';
        vAxis     = [-8, 8, -5, 5, -2, 2];
end

load([dirPath, fileName]);
load([dirPath, 'labels.mat']);

%%
full_label_struct{4}(:) = erase(full_label_struct{4}(:),'_');
%%
ax         = [];
subj_names = {'C01';'C02';'C03';'C04';'C05';'C06';'C07';'C08';'C10';'C11';'C12';'S01';'S02';'S03';'S04';'S05'};
color_list = {[0 1 1];
              [1 0 1];
              [0 1 0]}; % for 3 stimulations

figure; hold on; grid on; set(gca, 'FontSize', 20); ax(1) = gca;
num_sub = unique(full_label_struct{2});
for ii = 1 : length(num_sub)
    idx = find(full_label_struct{2} == num_sub(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx), 100, full_label_struct{2}(idx), 'Marker', 'x', 'LineWidth', 3);  
end
subj_str = subj_names(num_sub);
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
h = legend(subj_str(:), 'location','best'); set(h, 'Interpreter', 'Latex');
% title(title_str, 'Interpreter', 'Latex');
axis(vAxis);
% view(-89.46,11.92);


figure; hold on; grid on; set(gca, 'FontSize', 20); ax(2) = gca;
num_stim = unique(full_label_struct{3});
for ii = 1 : length(num_stim)
    idx = find(full_label_struct{3} == num_stim(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),30,'MarkerFaceColor',color_list{ii},'MarkerEdgeColor','none'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(full_label_struct{4}(:), 'Interpreter', 'latex', 'location', 'best');
% title(sprintf('PCA map, colored per stimulus %s', title_str),'interpreter','latex');
% view(-89.46,11.92);
axis(vAxis);
linkprop(ax,{'CameraPosition','CameraUpVector'}); 
