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
GeometryCase = PtAndRotationGeometry;

dirPath = ['./example_rotation_', num2str(subject), '_subj/'];
switch (GeometryCase)
    case RiemannianGeometry
        fileName  = 'Riemannian_Geometry/data.mat';
        title_str = 'Riemannian_Geometry';
        vAxis     = [-5.5, 5, -4, 3];
    case PtGeometry
        fileName  = 'PT/data_PT.mat';
        title_str = 'PT';
        vAxis     = [-6.2, 5, -2, 2.7];
    case PtAndRotationGeometry
        fileName  = 'PT_and_rotation/data_rot.mat';
        title_str = 'PT and rotation';
        vAxis     = [-6.5, 4.8, -2, 1.8];
end

load([dirPath, fileName]);
load([dirPath, 'labels.mat']);

%%
full_label_struct{4}(:) = eraseBetween(full_label_struct{4}(:),'_',' ');
full_label_struct{4}(:) = lower(extractAfter(full_label_struct{4}(:),"_"));

%%
ax         = [];
subj_names = {'C01';'C02';'C03';'C04';'C05';'C06';'C07';'C08';'C10';'C11';'C12';'S01';'S02';'S03';'S04';'S05'};
color_list = {[0 1 1];
              [1 0 1];
              [0 1 0]}; % for 3 stimulations

figure; hold on; grid on; ax(1) = gca;
num_sub = unique(full_label_struct{2});
for ii = 1 : length(num_sub)
    idx = find(full_label_struct{2} == num_sub(ii));
    scatter(pca_vec(1,idx), pca_vec(2,idx),  100, full_label_struct{2}(idx), 'Marker', 'x', 'LineWidth', 3);  
end
subj_str = subj_names(num_sub);
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
h = legend(subj_str(:), 'location','best'); set(h, 'Interpreter', 'Latex');
% title(title_str, 'Interpreter', 'Latex');
axis(vAxis);
set_figure_prop;

figure; hold on; grid on; ax(2) = gca;
num_stim = unique(full_label_struct{3});
for ii = 1 : length(num_stim)
    idx = find(full_label_struct{3} == num_stim(ii));
    scatter(pca_vec(1,idx), pca_vec(2,idx),40,'MarkerFaceColor',color_list{ii},'MarkerEdgeColor','none'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
legend(full_label_struct{4}(:), 'Interpreter', 'latex', 'location', 'best');
% title(sprintf('PCA map, colored per stimulus %s', title_str),'interpreter','latex');
axis(vAxis); 
set_figure_prop;

linkprop(ax,{'CameraPosition','CameraUpVector'}); 
set(ax, 'FontSize', 17);