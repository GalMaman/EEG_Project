%%
close all
clear
dirPath  = 'C:\Users\User\Desktop\gal\Technion\EEG_Project\Paper\figures\NewData\8subj\';
fileName = '8subj.mat';
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
% figure_struct{1,3} = [-8.5, 8.5, -8.5, 6.1];
% figure_struct{2,3} = [-5.5, 8, -4.3, 6];
% figure_struct{3,3} = [-10.5, 5.5, -6, 4.5];
% figure_struct{4,3} = [-69.5, -53, -112, -95];

% axis 8 subj
figure_struct{1,3} = [-20, 20, -10.5, 10];
figure_struct{2,3} = [-15, 20, -5, 11];
figure_struct{3,3} = [-19, 16, -16, 8];
figure_struct{4,3} = [112, 150, -3, 16];


%%
for ii = 1 : 3
    plot_mat(figure_struct{ii,1},full_label_struct,figure_struct{ii,3},figure_struct{ii,2});
end

