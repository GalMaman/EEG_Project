function [PCA_matrix, train_data, test_data,idx_test] = SVM_script_for_PCA(pca_vec, dat_lengths, full_label_struct, leave_out,stims_type)
num_sub = unique(full_label_struct{2});

if stims_type == 1
    label_stimulus_type(find(full_label_struct{3} < 3))  = 1;
    label_stimulus_type(find(full_label_struct{3} == 3)) = 2;
    label_stimulus_type(find(full_label_struct{3} > 3))  = 3;
else
    label_stimulus_type = full_label_struct{3}';
end
    
PCA_matrix = [label_stimulus_type' pca_vec];
idx_train  = find(full_label_struct{2} ~= num_sub(leave_out));
idx_test   = find(full_label_struct{2} == num_sub(leave_out));
train_data = PCA_matrix(idx_train,:);
test_data  = PCA_matrix(idx_test,:);

