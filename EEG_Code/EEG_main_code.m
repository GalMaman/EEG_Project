%% Gilad & Ronen, mapping using diffusion maps
% Insert the folders of the cov matrices you want to map out, and it
% applies diffusion maps to these matrices.
clear;
clc;

%%
addpath(genpath('./'));

%% entering the 'edited_EEG_data' directory
% example in Gal's:     E:\EEG_Project\CleanData\edited_EEG_data
% example in Gilad's:   E:\Gilad\Psagot\Technion\Semester6\Project1\EEG_data_files\EEG_data_edited\edited_EEG_data
% example in Ronen's:   C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\C04\16\cov
% example save Ronen's: C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\cov_mats_in_rows

%% parameters
src_dir            = 'E:\EEG_Project\CleanData\edited_EEG_data';
elec_param         = 1;
covariance_param   = 1; %choose covariance or kernel!
kernel_param       = 0;
Fourier_param      = 0;
PT_param           = 1;
no_PT_param        = 1;
pca_param          = 1;
tSNE_param         = 1;
diffMap_param      = 1;
tSNE_diffMap_param = 1;
num_of_trials      = 50; % to load all trials enter inf 

%% choosing subjects
subjs      = find_subject_names(src_dir);
pick_subj  = listdlg('PromptString', 'Select subjects;', 'SelectionMode',...
    'multiple', 'ListString', subjs);
subj_names = subjs(pick_subj);

%% choosing stims
stims      = find_stims( src_dir, subj_names );
pick_stims = listdlg('PromptString', 'Select stimulations;', 'SelectionMode',...
    'multiple', 'ListString', stims);
stim_names = stims(pick_stims);

%% Adding trials from chosen subjects and stims into cells
tic
[data_cell, legend_cell, label_struct] = load_trials( pick_stims, pick_subj,subjs, src_dir, stims,num_of_trials);
disp('    --finished loading all trials');
toc

%% pick electrodes
elec_array = [12, 26, 35, 41, 53];
if elec_param == 1
    [data_cell] = choose_electrodes(data_cell, pick_stims, pick_subj, elec_array);
end

%% Fourier transform
n_fourier = 500;
if Fourier_param == 1
    [data_cell] = creating_fourier_cell(data_cell, pick_stims, pick_subj, n_fourier);
    disp('    --finished calculating fourier matrices');
    toc
end

%% calculate covariance matrices
if covariance_param == 1
    [data_cell] = creating_cov_cell(data_cell, pick_stims, pick_subj);
    disp('    --finished calculating covariance matrices');
    toc
end

%% calculate kernel matrices
if kernel_param == 1
    [data_cell] = creating_kernal_cell(data_cell, pick_stims, pick_subj);
    disp('    --finished calculating kernel matrices');
    toc
end

%% labels struct
[cov_3Dmat, dat_lengths, full_label_struct] = CellToMat3D(data_cell,label_struct);

%% changing covs to matrices around common mean 
if no_PT_param == 1
    [cov_mat] = cov2vec(cov_3Dmat);
                                    % the matrix of cov-vectors                               
    disp('    --found Riemanien mean');
    toc
end

%% Parallel Transport
if PT_param == 1
    [cov_mat_PT] = Parallel_Tranport(cov_3Dmat);
    disp('    --found Riemanien mean with PT');
    toc
end

%% Running PCA on the Riemannian vectors
ax1 = [];
if (pca_param == 1)&&(no_PT_param == 1)
    [ pca_vec, ax1 ] = plot_PCA(cov_mat, full_label_struct, subj_names, []);
    linkprop(ax1,{'CameraPosition','CameraUpVector'}); 
    disp('    --finished PCA');
    toc
end

%% PCA by Gal PT
if (pca_param == 1)&&(PT_param == 1)
    [ pca_vec_PT, ax2 ] = plot_PCA(cov_mat_PT, full_label_struct, subj_names, 'with PT');
    linkprop([ax1 ,ax2],{'CameraPosition','CameraUpVector'});
    disp('    --finished PCA');
    toc
end

%% t-SNE
if (tSNE_param == 1)&&(no_PT_param == 1)
    % plot t-SNE subj
    figure; mZ = TSNE(cov_mat', full_label_struct{2}, 2 , [], 30);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects'); % plot per subject
    
    % plot t-SNE stim
    figure; mZ = TSNE(cov_mat', full_label_struct{3}, 2 , [], 30);
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus'); % plot per stimulation
    disp('    --finished t-SNE without PT');
    toc
end

%% t-SNE PT
if (tSNE_param == 1)&&(PT_param == 1)
    % plot t-SNE subj PT
    figure; mZ = TSNE(cov_mat_PT', full_label_struct{2}, 2 , [], 30);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects, with PT'); % plot per subject

    % plot t-SNE stim PT
    figure; mZ = TSNE(cov_mat_PT', full_label_struct{3}, 2 , [], 30);
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus, with PT'); % plot per stimulation
    disp('    --finished t-SNE with PT');
    toc
end

%% Now we'll run a diffusion map
if (diffMap_param == 1)&&(no_PT_param == 1)
    [ diffusion_matrix, diffusion_eig_vals, type_label ] = Diff_map( cov_mat, dat_lengths, legend_cell, full_label_struct{1});
    disp('    --wrote down diffusion maps');
    % diffusion_matrix =[];
    toc
end

%% Now we'll run a diffusion map PT
if (diffMap_param == 1)&&(PT_param == 1)
    [ diffusion_matrix_PT, diffusion_eig_vals_PT, type_label ] = Diff_map( cov_mat_PT, dat_lengths, legend_cell, full_label_struct{1});
    disp('    --wrote down diffusion maps with PT');
    % diffusion_matrix =[];
    toc
end

%% t-SNE on diffusion matrix
if (tSNE_diffMap_param == 1)&&(no_PT_param == 1)
    % plot t-SNE subj    
    P = 20;
    figure; mZ = TSNE(diffusion_matrix(:,2:P) * diffusion_eig_vals(2:P,2:P), full_label_struct{2}, 2, [], 50);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects, after diffusion maps'); % plot per subject
    
    % plot t-SNE stim
    figure; mZ = TSNE(diffusion_matrix(:,2:P) * diffusion_eig_vals(2:P,2:P), full_label_struct{3}, 2, [], 50);
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus, after diffusion maps'); % plot per stimulation
    disp('    --finished t-SNE without PT,  after diffusion maps');
    toc
end
    
%% t-SNE on diffusion matrix PT  
if (tSNE_diffMap_param == 1)&&(PT_param == 1)
    % plot t-SNE subj PT
    P = 20;
    figure; mZ = TSNE(diffusion_matrix_PT(:,2:P) * diffusion_eig_vals_PT(2:P,2:P), full_label_struct{2}, 2, [], 50);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects, with PT, after diffusion maps'); % plot per subject
    % plot t-SNE stim PT
    figure; mZ = TSNE(diffusion_matrix_PT(:,2:P) * diffusion_eig_vals_PT(2:P,2:P), full_label_struct{3}, 2, [], 50);
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus, with PT, after diffusion maps'); % plot per stimulation    
    disp('    --finished t-SNE with PT,  after diffusion maps');
    toc
end

%% saving the data
% data_struct = struct('subjects', cell2mat(subj_names), 'stimulations', cell2mat(stim_names), ...
%     'diffusion_matrix', diffusion_matrix, 'PCA_matrix', pca_vec, 'labels',...
%     label_vec, 'type_labels', type_label);
% 
% prompt    = {'Enter save destination directory:', 'Choose filename:'};
% dir_title = 'save';
% dest_cell = inputdlg(prompt,dir_title);
% dest_dir  = dest_cell{1};
% filename  = [dest_cell{2},'.mat'];
% cd(dest_dir);
% save(filename, 'data_struct');

%% preparing matrix for SVM train
leave_out = 1;
[train_data, test_data] = SVM_script_for_PCA(pca_vec, dat_lengths, full_label_struct, leave_out);
[train_data_PT, test_data_PT] = SVM_script_for_PCA(pca_vec_PT, dat_lengths, full_label_struct, leave_out);

%% SVM
[trainedClassifier, validationAccuracy] = AllSVM_trainClassifier(train_data);
data_for_training = test_data(:,2:end);
yfit = trainedClassifier.predictFcn(data_for_training);
C    = confusionmat(test_data(:,1),yfit);
figure();heatmap(C);
% plotconfusion(test_data(:,1),yfit);

%% SVM PT

[trainedClassifier_PT, validationAccuracy_PT] = AllSVM_trainClassifier(train_data_PT);
data_for_training_PT = test_data_PT(:,2:end);
yfit_PT = trainedClassifier_PT.predictFcn(data_for_training_PT);
CPT    = confusionmat(test_data_PT(:,1),yfit_PT);
figure();heatmap(CPT);
