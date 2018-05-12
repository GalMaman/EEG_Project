function [percentage] = calculate_elec_score(test_mat, dat_lengths, full_label_struct)

% organize data
num_sub   = unique(full_label_struct{2});  
num_stim  = unique(full_label_struct{3});
data_mat  = [full_label_struct{3} test_mat'];
idx_train = [];
idx_test  = [];
start_idx = 1;

for jj = 1 : length(num_sub)
    for ii = 1 : length(num_stim)
        num_train = ceil(0.8 * dat_lengths(ii,jj));
        idx_train = [idx_train; (start_idx : start_idx + num_train - 1)'];
        idx_test  = [idx_test; (start_idx + num_train : start_idx + dat_lengths(ii,jj) - 1)'];
        start_idx = start_idx + dat_lengths(ii,jj);
    end
end
train_data = data_mat(idx_train,:);
test_data  = data_mat(idx_test,:);

% classification
[trainedClassifier, ~] = linSVM1subj_trainClassifier(train_data);
data_for_testing       = test_data(:,2:end);
yfit                   = trainedClassifier.predictFcn(data_for_testing);

% score
known_label     = test_data(:,1);
predicted_label = yfit;
c_mat           = confusionmat(known_label, predicted_label);
percentage      = 100 * trace(c_mat) / sum(c_mat(:));

