function [cov_mat_PT, Riemannian_3Dmat] = Parallel_Tranport(cov_3Dmat)

num_of_subj          = size(cov_3Dmat,2);
RiemannianMean_3Dmat = [];

for jj = 1 : num_of_subj
    mRiemannianMean      = RiemannianMean(cov_3Dmat{1,jj}); %calculating riemannian mean for each subject
    RiemannianMean_3Dmat = cat(3, RiemannianMean_3Dmat, mRiemannianMean);
end

Riemannian_3Dmat = [];
Pmean            = RiemannianMean(RiemannianMean_3Dmat); % calculating mean of all riemannian means
for jj = 1 : num_of_subj
     K  = size(cov_3Dmat{1,jj}, 3);
     for kk = 1 : K  % performing parallel transport for all the trials
         mC   = cov_3Dmat{1,jj}(:, :, kk); 
         temp = 0.5*log_mat(mC, Pmean);
         temp = exp_mat(mC, temp);
         temp = 2*log_mat(RiemannianMean_3Dmat(:,:,jj), temp);
         cov_3Dmat{1,jj}(:, :, kk) = exp_mat(RiemannianMean_3Dmat(:,:,jj), temp); 

%           cov_3Dmat{1,jj}(:, :, kk) = SchildLadder(RiemannianMean_3Dmat(:,:,jj), Pmean, mC);
         
     end
     Riemannian_3Dmat = cat(3, Riemannian_3Dmat, cov_3Dmat{1,jj}); 
end

cov_mat_PT = CovsToVecs(Riemannian_3Dmat, Pmean);

end
