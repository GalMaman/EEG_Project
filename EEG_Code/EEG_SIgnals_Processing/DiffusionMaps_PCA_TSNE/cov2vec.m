function [ cov_mat, dat_lengths, label_vec_con, label_vec_sub, label_vec_stim ] = cov2vec( data_cell, directories, label_con, label_sub, label_st)
% Recives the directories that contain all the cov matrices
%% orderering all the covs
cov_cell = [];

dat_lengths = zeros(size(data_cell));
for ii = 1:length(data_cell(:))
    dat_lengths(ii) = length(data_cell{ii});
    cov_cell        = [cov_cell ; data_cell{ii}];
end    


%% Now we calculate the Riemannian mean iteratively
M = length(cov_cell);
[rows, cols] = size(cov_cell{1});
cov_3Dmat    = zeros(rows, cols,M);
for jj = 1: M
    cov_3Dmat(:, :, jj) =  cov_cell{jj};
end
cov_mat = CovsToVecs(cov_3Dmat, 1, []);

label_vec_con = [];
label_vec_sub = [];
label_vec_stim = [];
for ii = 1: length(dat_lengths(:))
    label_vec_con = [label_vec_con; label_con(ii) * ones(dat_lengths(ii),1)];
    label_vec_sub = [label_vec_sub; label_sub(ii) * ones(dat_lengths(ii),1)];
    label_vec_stim = [label_vec_stim; label_st(ii) * ones(dat_lengths(ii),1)];

end
end

