function [ cov_mat, dat_lengths, label_vec ] = cov2vec( data_cell, directories, label)
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
cov_mat = CovsToVecs(cov_3Dmat);

label_vec = [];
for ii = 1: length(dat_lengths(:))
    label_vec = [label_vec; label(ii) * ones(dat_lengths(ii),1)];
end
end

