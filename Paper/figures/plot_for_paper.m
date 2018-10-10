%%
close all
clear
dirPath  = 'C:\Users\User\Desktop\gal\Technion\EEG_Project\Paper\figures\figures_9_10\';
fileName = '11subj.mat';
load([dirPath, fileName]);

figure_struct = cell(4,3);
% data 
figure_struct{1,1} = pca_vec;
figure_struct{2,1} = pca_vec_PT;
figure_struct{3,1} = pca_vec_rot;
figure_struct{4,1} = pca_vec_MT;
% title
figure_struct{1,2} = 'Riemannian Geometry';
figure_struct{2,2} = 'PT';
figure_struct{3,2} = 'PT and Rotation';
figure_struct{4,2} = 'Mean Transport';
% axis 2 subj
% figure_struct{1,3} = [-8, 8, -9, 6];
% figure_struct{2,3} = [-5, 8, -4.3, 5.5];
% figure_struct{3,3} = [-10.5, 5.5, -6, 4.5];
% figure_struct{4,3} = [-1.5e-6, 1.2e-6, -5.5e-7, 4.5e-7];

% axis 8 subj
figure_struct{1,3} = [-20, 25, -9, 12];
figure_struct{2,3} = [-20, 24, -10, 6];
figure_struct{3,3} = [-20, 20, -15, 8];
figure_struct{4,3} = [-4e-6, 5.5e-6, -1e-6, 1e-6];


%%
for ii = 1:4
    plot_mat(figure_struct{ii,1},full_label_struct,figure_struct{ii,3},figure_struct{ii,2});
end

