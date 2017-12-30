function [train_data, test_data] = SVM_script_for_PCA(pca_vec, dat_lengths, full_label_struct, leave_out)

% pca_labels = [];
% count      = 1;
% stim_vec   = [1, 2, 3, 11, 12, 13, 14, 15, 16];
% stim_vec   = [1, 3, 14];
% idx        = 1;
label_stimulus_type(find(full_label_struct{3} < 3))  = 1;
label_stimulus_type(find(full_label_struct{3} == 3)) = 2;
label_stimulus_type(find(full_label_struct{3} > 3))  = 3;

% stim_vec = unique(label_stimulus_type);

% for ii = 1: length(dat_lengths(:))
%     pca_labels = [pca_labels ; stim_vec(idx) * ones(dat_lengths(ii),1)];
%     count      = count + 1;
%     idx        = idx + 1;
%     if count == 4
%         count = 1;
%         idx   = 1;
%     end
% end
    
PCA_matrix = [label_stimulus_type', pca_vec];
idx_train  = find(full_label_struct{2} ~= leave_out);
idx_test   = find(full_label_struct{2} == leave_out);
train_data = PCA_matrix(idx_train,:);
test_data  = PCA_matrix(idx_test,:);

