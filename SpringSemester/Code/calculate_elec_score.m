function [percentage] = calculate_elec_score(test_mat, dat_lengths, full_label_struct)

% organize data
num_sub   = unique(full_label_struct{2});  
num_stim  = unique(full_label_struct{3});


if (length(num_stim) == 2) && (size(test_mat,1) == 1)
    labels = zeros(size(full_label_struct{3},1),1);
    if sum(test_mat(1,full_label_struct{3} == num_stim(1))) > 0
        for ii = 1 : size(test_mat,2)
            if test_mat(1,ii) > 0
              labels(ii) = num_stim(1);
            else
              labels(ii) = num_stim(2);
            end
        end
    else
        for ii = 1 : size(test_mat,2)
            if test_mat(1,ii) < 0
              labels(ii) = num_stim(1);
            else
              labels(ii) = num_stim(2);
            end
        end
    end
    predicted_label = labels;
    known_label     = full_label_struct{3};

else
    data_mat  = [full_label_struct{3} test_mat'];
    rand_idx  = randperm(size(data_mat,1));
    idx_train = [];
    idx_test  = [];
    start_idx = 1;
    for jj = 1 : length(num_sub)
        for ii = 1 : length(num_stim)
            num_train  = ceil(0.8 * dat_lengths(ii,jj));
            stim_idx   = start_idx : start_idx + dat_lengths(ii,jj) - 1;
            stim_idx   = stim_idx(randperm(length(stim_idx)));
            stim_train = stim_idx(1 : num_train);
            idx_train  = [idx_train; stim_train'];
            stim_test  = stim_idx(1 + num_train : dat_lengths(ii,jj));
            idx_test   = [idx_test; stim_test'];
            start_idx  = start_idx + dat_lengths(ii,jj);
        end
    end
    train_data = data_mat(rand_idx(idx_train),:);
    test_data  = data_mat(rand_idx(idx_test),:);

    % classification
    [trainedClassifier, ~] = LinSVM2Elec_trainClassifier(train_data);
    data_for_testing       = test_data(:,2:end);
    yfit                   = trainedClassifier.predictFcn(data_for_testing);

    % score
    known_label     = test_data(:,1);
    predicted_label = yfit;
end

c_mat           = confusionmat(known_label, predicted_label);
percentage      = 100 * trace(c_mat) / sum(c_mat(:));
