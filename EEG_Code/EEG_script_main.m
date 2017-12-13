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

src_dir    = 'E:\EEG_Project\CleanData\edited_EEG_data';

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
num_of_trials = 200; % to load all trial enter inf
[ data_cell, legend_cell, legend_str,label_con,label_sub, label_st, stims_str] = load_trials( pick_stims, pick_subj,subjs, src_dir, stims,num_of_trials);
disp('    --finished loading all trials');
toc

%% calculate covariance matrices
[cov_data_cell] = creating_cov_cell(data_cell, pick_stims, pick_subj);
disp('    --finished calculating covariance matrices');
toc

%% calculate kernel matrices
[kernel_data_cell] = creating_kernal_cell(data_cell, pick_stims, pick_subj);
disp('    --finished calculating kernel matrices');
toc

%% changing covs to matrices around common mean 
[cov_mat, dat_lengths, label_vec_con, label_vec_sub, label_vec_stim ] = cov2vec( cov_data_cell, [], label_con, label_sub, label_st);
                                % the matrix of cov-vectors                               
disp('    --found Riemanien mean');
toc

%% Parallel Transport
[cov_mat_PT, dat_lengths_PT, label_vec_con_PT, label_vec_sub_PT, label_vec_stim_PT] = Parallel_Tranport(cov_data_cell, [],  label_con, label_sub, label_st);
disp('    --found Riemanien mean with PT');
toc

%% Running PCA on the Riemannian vectors
% [pca_vec, PCA_type_label] = PCA_map( cov_mat, dat_lengths, legend_cell, label_vec_con, label_vec_sub, label_vec_stim );
% disp('    --finished PCA');
% toc
% 
% % Running PCA on the Riemannian vectors
% [pca_vec, PCA_type_label] = PCA_map( cov_mat_PT, dat_lengths_PT, legend_cell, label);
% disp('    --finished PCA');
% toc

%% PCA by Gal
[ pca_vec ] = plot_PCA(cov_mat, label_vec_con, label_vec_sub, label_vec_stim, subj_names, stims_str);
disp('    --finished PCA');
toc

%% PCA by Gal PT
[ pca_vec_PT ] = plot_PCA(cov_mat_PT, label_vec_con_PT, label_vec_sub_PT, label_vec_stim_PT, subj_names, stims_str);
disp('    --finished PCA');
toc

%% plot t-SNE subj
figure; mZ = TSNE(cov_mat', label_vec_sub, 2 , dat_lengths, 30);
plot_tSNE(mZ, label_vec_sub, subj_names, 'subjects'); % plot per subject

%% plot t-SNE subj PT
figure; mZ = TSNE(cov_mat_PT', label_vec_sub_PT, 2 , dat_lengths_PT, 30);
plot_tSNE(mZ, label_vec_sub_PT, subj_names, 'subjects'); % plot per subject

%% plot t-SNE stim
figure; mZ = TSNE(cov_mat', label_vec_stim, 2 , dat_lengths, 30);
plot_tSNE(mZ, label_vec_stim, stims_str, 'stimulations'); % plot per stimulation

%% plot t-SNE stim PT
figure; mZ = TSNE(cov_mat_PT', label_vec_stim_PT, 2 , dat_lengths_PT, 30);
plot_tSNE(mZ, label_vec_stim_PT, stims_str, 'stimulations'); % plot per stimulation

%% Now we'll run a diffusion map
[ diffusion_matrix, diffusion_eig_vals, type_label ] = Diff_map( cov_mat, dat_lengths, legend_cell, label_vec_con);
disp('    --wrote down diffusion maps');
% diffusion_matrix =[];
toc

%% Now we'll run a diffusion map PT
[ diffusion_matrix_PT, diffusion_eig_vals, type_label ] = Diff_map( cov_mat_PT, dat_lengths_PT, legend_cell, label_vec_con_PT);
disp('    --wrote down diffusion maps with PT');
% diffusion_matrix =[];
toc

%% saving the data
data_struct = struct('subjects', cell2mat(subj_names), 'stimulations', cell2mat(stim_names), ...
    'diffusion_matrix', diffusion_matrix, 'PCA_matrix', pca_vec, 'labels',...
    label_vec, 'type_labels', type_label);

prompt    = {'Enter save destination directory:', 'Choose filename:'};
dir_title = 'save';
dest_cell = inputdlg(prompt,dir_title);
dest_dir  = dest_cell{1};
filename  = [dest_cell{2},'.mat'];
cd(dest_dir);
save(filename, 'data_struct');

%% preparing matrix for SVM train
PCA_matrix = SVM_script_for_PCA(mZ, dat_lengths_PT, stim_names);

