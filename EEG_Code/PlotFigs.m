close all;
clear;

load rotation_data\c01c02_1_3_11\subj_names.mat
load rotation_data\c01c02_1_3_11\full_label_struct.mat
load rotation_data\c01c02_1_3_11\cov_mat_PT.mat
load rotation_data\c01c02_1_3_11\cov_mat.mat

addpath(genpath('./'));

%% Running PCA on the Riemannian vectors
ax = [];
[ pca_vec, ax1 ] = plot_PCA(cov_mat, full_label_struct, subj_names, []);
ax = [ax, ax1];

%% PCA PT
[ pca_vec_PT, ax1 ] = plot_PCA(cov_mat_PT, full_label_struct, subj_names, 'with PT');
ax = [ax, ax1];

%% pca per subject (rotation) with PT
[pca_mat_PT, ax1] = plot_PCA_rot(cov_mat_PT, full_label_struct, subj_names);
ax = [ax, ax1];
linkprop(ax ,{'CameraPosition','CameraUpVector'});


