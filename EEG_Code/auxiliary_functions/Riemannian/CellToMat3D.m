function[cov_3Dmat, dat_lengths, full_label_struct] = CellToMat3D(data_cell,label_struct)

%% orderering all the covs
num_of_subj         = size(data_cell,2);
cov_cell            = cell(1, num_of_subj);
cov_3Dmat           = cell(1, num_of_subj);
dat_lengths         = zeros(size(data_cell));
for jj = 1 : num_of_subj
    for ii = 1 : size(data_cell, 1)
        dat_lengths(ii,jj) = length(data_cell{ii,jj});
        cov_cell{jj}       = [cov_cell{jj}; data_cell{ii,jj}];
    end
    cov_3Dmat{1,jj} = cat(3, cov_cell{1,jj}{:});
end

full_label_struct    = cell(4,1);
full_label_struct{4} = label_struct{5};
for ii = 1: length(dat_lengths(:))
    full_label_struct{1} = [full_label_struct{1}; label_struct{2}(ii) * ones(dat_lengths(ii),1)];
    full_label_struct{2} = [full_label_struct{2}; label_struct{3}(ii) * ones(dat_lengths(ii),1)];
    full_label_struct{3} = [full_label_struct{3}; label_struct{4}(ii) * ones(dat_lengths(ii),1)];
end