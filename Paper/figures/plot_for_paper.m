%%
close all
clear
dirPath  = 'C:\Users\User\Desktop\gal\Technion\EEG_Project\poster_data\8subj\';
fileName = '8subj.mat';
load([dirPath, fileName]);

figure_struct = cell(3,3);
% data 
figure_struct{1,1} = pca_vec;
figure_struct{2,1} = pca_vec_PT;
figure_struct{3,1} = pca_vec_rot;

% title
figure_struct{1,2} = 'Riemannian Geometry';
figure_struct{2,2} = 'PT';
figure_struct{3,2} = 'PT and Rotation';

% axis 2 subj
% figure_struct{1,3} = [-8.5, 8.5, -8.5, 6.2];
% figure_struct{2,3} = [-8.5, 6, -4.3, 7];
% figure_struct{3,3} = [-10, 6, -6, 6];

% axis 8 subj
figure_struct{1,3} = [-25, 20, -9, 8];
figure_struct{2,3} = [-22, 15, -7, 10];
figure_struct{3,3} = [-19, 16, -16, 8];

%%
for ii = 1 : 3
    plot_mat(figure_struct{ii,1},full_label_struct,figure_struct{ii,3},figure_struct{ii,2});
end

