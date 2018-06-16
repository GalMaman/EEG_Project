function [cov_mat_PT, Riemannian_3Dmat] = NEW_Parallel_Tranport(cov_3Dmat)

num_of_subj          = size(cov_3Dmat,2);
RiemannianMean_3Dmat = [];

for jj = 1 : num_of_subj
    mRiemannianMean      = RiemannianMean(cov_3Dmat{1,jj}); %calculating riemannian mean for each subject
    RiemannianMean_3Dmat = cat(3, RiemannianMean_3Dmat, mRiemannianMean);
end

Riemannian_3Dmat = cov_3Dmat{1,1};
% Pmean            = RiemannianMean(RiemannianMean_3Dmat); % calculating mean of all riemannian means
Pmean = RiemannianMean_3Dmat(:,:,1);
for jj = 2 : num_of_subj
     E  = (Pmean * (RiemannianMean_3Dmat(:,:,jj))^(-1))^(0.5);
     K  = size(cov_3Dmat{1,jj}, 3);
     for kk = 1 : K  % performing parallel transport for all the trials

         cov_3Dmat{1,jj}(:, :, kk) = E * cov_3Dmat{1,jj}(:, :, kk) * E'; 

%           cov_3Dmat{1,jj}(:, :, kk) = SchildLadder(RiemannianMean_3Dmat(:,:,jj), Pmean, mC);
         
     end
     Riemannian_3Dmat = cat(3, Riemannian_3Dmat, cov_3Dmat{1,jj}); 
end
white      = 1;
cov_mat_PT = CovsToVecs(Riemannian_3Dmat, white, Pmean);
end
