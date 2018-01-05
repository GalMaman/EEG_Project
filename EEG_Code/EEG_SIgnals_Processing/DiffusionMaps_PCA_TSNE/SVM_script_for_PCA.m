function [train_data, test_data] = SVM_script_for_PCA(pca_vec, dat_lengths, full_label_struct, leave_out)

label_stimulus_type(find(full_label_struct{3} < 3))  = 1;
label_stimulus_type(find(full_label_struct{3} == 3)) = 2;
label_stimulus_type(find(full_label_struct{3} > 3))  = 3;

    
PCA_matrix = [label_stimulus_type', pca_vec];
idx_train  = find(full_label_struct{2} ~= leave_out);
idx_test   = find(full_label_struct{2} == leave_out);
train_data = PCA_matrix(idx_train,:);
test_data  = PCA_matrix(idx_test,:);

