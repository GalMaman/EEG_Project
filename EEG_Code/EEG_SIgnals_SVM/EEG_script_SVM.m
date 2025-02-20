%% Gilad and Ronen - 28.08.17
% Using SVM to classify sick/healthy patients from diffusion maps
% This is only good for seperating between sick and healthy, not between
% stims. For that, use the classifier app.
clear; clc;
%% Loading Struct with data from diff_maps script.
% struct look thus:
    % data_struct = struct('subjects', cell2mat(subj_names), 'stimulations', cell2mat(stim_names), ...
    %   'diffusion_matrix', diffusion_matrix, 'PCA_matrix', pca_vec, 'labels', label_vec, 'type_labels', type_label);

% Loading data:
[data_cell, picked_files] = load_SVMdata(); 
% this cell contains structs, of different names, each containing the 
% struct named 'data_struct'. This has the description above.

%% Verifying data 
data_struct = data_cell{1}.data_struct;
n_sick      = length(find(contains(num2cell(data_struct.subjects(:,1)), 'S')));
if (n_sick < 2)
    errordlg('Please choose at least two sick subjects');
    return
elseif (size(data_struct.subjects,1)-n_sick < 2)
    errordlg('Please choose at least two healthy subjects');
    return
end
    
%% Preparing for SVM:
[leftout, sick_indicator, diff_mat, pca_mat, type_vec, stim_num] = ...
                    choose_learning_aspects(data_struct);
%% Beginning cells:
n = size(leftout,1);

% and SVM models:
SVM_diff_type        = cell(n,1);
SVM_diff_sh          = cell(n,1);
gaussSVM_diff_test   = cell(n,1);
% diffusion:
test_diff_cell       = cell(n,1);
train_diff_cell      = cell(n,1);

diff_SVM_lin_model   = cell(n,1);
diff_SVM_cub_model   = cell(n,1);
diff_SVM_gauss_model = cell(n,1);

lin_confmat_diff     = cell(n,1);
cub_confmat_diff     = cell(n,1);
gauss_confmat_diff   = cell(n,1);
% PCA:
test_pca_cell        = cell(n,1);
train_pca_cell       = cell(n,1);

pca_SVM_lin_model    = cell(n,1);
pca_SVM_cub_model    = cell(n,1);
pca_SVM_gauss_model  = cell(n,1);

lin_confmat_pca      = cell(n,1);
cub_confmat_pca      = cell(n,1);
gauss_confmat_pca    = cell(n,1);
%% Running over all rows:
for ii = 1:n
    [test_diff_cell{ii}, train_diff_cell{ii}, test_pca_cell{ii}, train_pca_cell{ii}] = ...
            prepareSVM( diff_mat, pca_mat, leftout(ii,:), type_vec, stim_num);
    %% building SVM models:
    % model according to sick/healthy, over diff_maps:
    [diff_SVM_lin_model{ii}, ~]   = train_SVM_linear(train_diff_cell{ii});
    [diff_SVM_cub_model{ii}, ~]   = train_SVM_cubic(train_diff_cell{ii});
    [diff_SVM_gauss_model{ii}, ~] = train_SVM_gauss(train_diff_cell{ii});
    % model according to sick/healthy, over pca_maps:
    [pca_SVM_lin_model{ii}, ~]    = train_SVM_linear(train_pca_cell{ii});
    [pca_SVM_cub_model{ii}, ~]    = train_SVM_cubic(train_pca_cell{ii});
    [pca_SVM_gauss_model{ii}, ~]  = train_SVM_gauss(train_pca_cell{ii});
    %% testing and checking outcome:
    % diffusion maps:
    % Linear:
    linSVM_diff_test{ii}   = diff_SVM_lin_model{ii}.predictFcn(test_diff_cell{ii}(:, 1:end-2));
    lin_confmat_diff{ii}   = confusionmat(linSVM_diff_test{ii}, test_diff_cell{ii}(:, end));
    plot_decision_space(diff_SVM_lin_model{ii}, diff_mat, 'Diff Linear SVM model');
    % Quad:
    cubSVM_diff_test{ii}   = diff_SVM_cub_model{ii}.predictFcn(test_diff_cell{ii}(:, 1:end-2));
    cub_confmat_diff{ii}   = confusionmat(cubSVM_diff_test{ii}, test_diff_cell{ii}(:, end));
    plot_decision_space(diff_SVM_cub_model{ii}, diff_mat, 'Diff Cubic SVM model');
    % Gauss:
    gaussSVM_diff_test{ii} = diff_SVM_gauss_model{ii}.predictFcn(test_diff_cell{ii}(:, 1:end-2));
    gauss_confmat_diff{ii} = confusionmat(gaussSVM_diff_test{ii}, test_diff_cell{ii}(:, end));
    plot_decision_space(diff_SVM_gauss_model{ii}, diff_mat, 'Diff medium Gaussian SVM model');
    % PCA:
    % Linear:
    linSVM_pca_test{ii}    = pca_SVM_lin_model{ii}.predictFcn(test_pca_cell{ii}(:, 1:end-2));
    lin_confmat_pca{ii}    = confusionmat(linSVM_pca_test{ii}, test_pca_cell{ii}(:, end));
    plot_decision_space(pca_SVM_lin_model{ii}, pca_mat, 'PCA Linear SVM model');
    % Quad:
    cubSVM_pca_test{ii}    = pca_SVM_cub_model{ii}.predictFcn(test_pca_cell{ii}(:, 1:end-2));
    cub_confmat_pca{ii}    = confusionmat(cubSVM_pca_test{ii}, test_pca_cell{ii}(:, end));
    plot_decision_space(pca_SVM_cub_model{ii}, pca_mat, 'PCA Cubic SVM model');
    % Gauss:
    gaussSVM_pca_test{ii}  = pca_SVM_gauss_model{ii}.predictFcn(test_pca_cell{ii}(:, 1:end-2));
    gauss_confmat_pca{ii}  = confusionmat(gaussSVM_pca_test{ii}, test_pca_cell{ii}(:, end));
    plot_decision_space(pca_SVM_gauss_model{ii}, pca_mat, 'PCA medium Gaussian SVM model');
end
%% saving the data
confmats       = cell(n_sick,6);
confmats(:,1)  = lin_confmat_diff;
confmats(:,2)  = cub_confmat_diff;
confmats(:,3)  = gauss_confmat_diff;
confmats(:,4)  = lin_confmat_pca;
confmats(:,5)  = cub_confmat_pca;
confmats(:,6)  = gauss_confmat_pca;
sick_array     = strings(1,n_sick);
for ii = 1:n_sick
    sick_array(1,ii) = sprintf('S%d_out',ii);
end

confmats_table = cell2table(confmats, 'VariableNames', {'linear_diff',...
    'cubic_diff', 'gaussian_diff', 'linear_pca', 'cubic_pca', 'gaussian_pca'},...
    'RowNames', cellstr(sick_array));
prompt={'Enter save destination directory:', 'Choose filename:'};
dir_title   = 'save';
dest_cell   = inputdlg(prompt,dir_title);
dest_dir    = dest_cell{1};
filename    = [dest_cell{2},'.mat'];
cd(dest_dir);
save(filename, 'confmats_table');
