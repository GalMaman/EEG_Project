clear;
close all; 

dim     = 10;
samples = 100;
mu2     = 1  * ones(10,1);
mu3     = 2 * ones(10,1);
mat1    = randn(dim, samples);
mat2    = randn(dim, samples) + mu2;
mat3    = randn(dim, samples) + mu3;

%%
vLabel  = [1 * ones(samples, 1);
           2 * ones(samples, 1);
           3 * ones(samples, 1)];
mrg_mat = [mat1, mat2, mat3];
figure; scatter3(mrg_mat(1,:), mrg_mat(2,:), mrg_mat(3,:), 100, vLabel, 'Fill');
% mrg_mat = mrg_mat(:, randperm(size(mrg_mat, 2)));

%% building matrices K, D, P
dis_mat = squareform( pdist(mrg_mat') );
epsilon = median(dis_mat(:));
K       = exp(-dis_mat.^2 / epsilon^2);
P       = K ./ sum(K, 2);

[Psi, Lmabda] = eig(P);
%% 
figure; scatter3(Psi(:,2), Psi(:,3), Psi(:,4), 100, vLabel, 'Fill');