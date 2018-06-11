function [cov_mat_mean] = Mean_Tranport(cov_3Dmat)

num_of_subj  = size(cov_3Dmat,2);
cov_mat_mean = [];

for jj = 1 : num_of_subj
    j_RiemannianMean = RiemannianMean(cov_3Dmat{1,jj}); %calculating riemannian mean for each subject
    cov_mat_mean     = [cov_mat_mean CovsToVecs(cov_3Dmat{1,jj}, j_RiemannianMean)];
end