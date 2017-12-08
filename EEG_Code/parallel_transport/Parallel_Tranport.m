function [cov_mat_PT, dat_lengths, label_vec_con, label_vec_sub, label_vec_stim] = Parallel_Tranport(data_cell, directories,  label_con, label_sub, label_st)

num_of_subj         = size(data_cell,2);
cov_cell            = cell(1, num_of_subj);
cov_3Dmat           = cell(1, num_of_subj);
dat_lengths         = zeros(size(data_cell));
RiemannianMean_3Dmat =[];

for jj = 1 : num_of_subj
    for ii = 1 : size(data_cell, 1)
        dat_lengths(ii,jj) = length(data_cell{ii,jj});
        cov_cell{jj}       = [cov_cell{jj}; data_cell{ii,jj}];
    end
    cov_3Dmat{1,jj} = cat(3, cov_cell{1,jj}{:});
    mRiemannianMean      = RiemannianMean(cov_3Dmat{1,jj}); %calculating riemannian mean for each subject
    RiemannianMean_3Dmat = cat(3, RiemannianMean_3Dmat, mRiemannianMean);
end

Riemannian_3Dmat = [];
Pmean            = mean(RiemannianMean_3Dmat, 3); % calculating mean of all riemannian means
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

cov_mat_PT = CovsToVecs(Riemannian_3Dmat, 0, Pmean);

label_vec_con = [];
label_vec_sub = [];
label_vec_stim = [];
for ii = 1: length(dat_lengths(:))
    label_vec_con = [label_vec_con; label_con(ii) * ones(dat_lengths(ii),1)];
    label_vec_sub = [label_vec_sub; label_sub(ii) * ones(dat_lengths(ii),1)];
    label_vec_stim = [label_vec_stim; label_st(ii) * ones(dat_lengths(ii),1)];
end

end
