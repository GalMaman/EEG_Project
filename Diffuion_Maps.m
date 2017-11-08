clear; close all; 

dim     = 10;
samples = 100;
mu2     = 50*ones(10,1);
mu3     = 100*ones(10,1);
cov2    = 2;
cov3    = 1;
mat1    = randn(dim ,samples);
mat2    = cov2.*randn(dim ,samples)+ mu2;
mat3    = cov3.*randn(dim ,samples)+ mu3;
mrg_mat = [mat1(:); mat2(:) ; mat3(:)];
epsilon = 4;
%% building matrices K, D, P
dis_mat = squareform(pdist(mrg_mat));
K       = zeros(size(mrg_mat,1),size(mrg_mat,1));
for ii=1:size(mrg_mat,1)
    for jj=1:size(mrg_mat,1)
        K(ii,jj) = exp(-(dis_mat(ii, jj)^2)/epsilon);
    end
end

D = zeros(size(K,2), size(K,2)); %diagonal matrix 
for ii = 1:size(K,2)
    D(ii, ii) = sum(K(ii,:));
end

P          = inv(D)*K;
[V , S, W] = eig(P);
%% 
cmp=jet(size(V,2));
% figure()
% scatter3(S(1,1)*V(:,1),S(2,2)*V(:,2),S(3,3)*V(:,3),15, cmp);
% colorbar

V1 = V(: ,2);
V2 = V(:,3);
V3 = V(:,4);
mP1 = V1 * V1' * mrg_mat;
mP2 = V2 * V2' * mrg_mat;
mP3 = V3 * V3' * mrg_mat;
figure()
scatter3(mP1,mP2,mP3,15, cmp);

V1 = V(2,:);
V2 = V(3,:);
V3 = V(4,:);
mP1 = V1' * V1 * mrg_mat;
mP2 = V2' * V2 * mrg_mat;
mP3 = V3' * V3 * mrg_mat;
figure()
scatter3(mP1,mP2,mP3,15, cmp);