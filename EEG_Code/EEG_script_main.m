%% Gilad & Ronen, mapping using diffusion maps
% Insert the folders of the cov matrices you want to map out, and it
% applies diffusion maps to these matrices.
clear all;
clc;
%% entering the 'edited_EEG_data' directory
% example in Gal's:     E:\EEG_Project\CleanData\edited_EEG_data
% example in Gilad's:   E:\Gilad\Psagot\Technion\Semester6\Project1\EEG_data_files\EEG_data_edited\edited_EEG_data
% example in Ronen's:   C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\C04\16\cov
% example save Ronen's: C:\Users\Ronen\Documents\BrainStorm\brainstormdb\EEG_data\Edited_Data\cov_mats_in_rows

prompt     ={'Enter data directory'};
dir_title  = 'data';
src_cell   = inputdlg(prompt,dir_title);
src_dir    = src_cell{1};
cd(src_dir);

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
[data_cell, legend_cell, legend_str, label] = load_trials( pick_stims, pick_subj,subjs, src_dir, stims);
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
[cov_mat, dat_lengths, label_vec] = cov2vec( cov_data_cell, [], label);
                                % the matrix of cov-vectors
                                
disp('    --found Riemanien mean');
toc

%% Parallel Transport
[ cov_mat_PT, dat_lengths_PT, label_vec_PT ] = Parallel_Tranport( cov_data_cell, [], label);
disp('    --found Riemanien mean with PT');
toc
%% Running PCA on the Riemannian vectors
[pca_vec, PCA_type_label] = PCA_map( cov_mat, dat_lengths, legend_cell, label);
disp('    --finished PCA');
toc

%% Running PCA on the Riemannian vectors
[pca_vec, PCA_type_label] = PCA_map( cov_mat_PT, dat_lengths_PT, legend_cell, label);
disp('    --finished PCA');
toc
%% Running TSNE on the RIemannian vectors
% [RSNE_vec, TSNE_type_label] = TSNE_map( cov_mat, dat_lengths, legend_cell, label);

%% Now we'll run a diffusion map
[ diffusion_matrix, diffusion_eig_vals, type_label ] = Diff_map( cov_mat, dat_lengths, legend_cell, label);
disp('    --wrote down diffusion maps');
% diffusion_matrix =[];
toc

%% Now we'll run a diffusion map
[ diffusion_matrix, diffusion_eig_vals, type_label ] = Diff_map( cov_mat_PT, dat_lengths_PT, legend_cell, label);
disp('    --wrote down diffusion maps');
% diffusion_matrix =[];
toc

%% saving the data
data_struct = struct('subjects', cell2mat(subj_names), 'stimulations', cell2mat(stim_names), ...
    'diffusion_matrix', diffusion_matrix, 'PCA_matrix', pca_vec, 'labels',...
    label_vec, 'type_labels', PCA_type_label);

prompt    = {'Enter save destination directory:', 'Choose filename:'};
dir_title = 'save';
dest_cell = inputdlg(prompt,dir_title);
dest_dir  = dest_cell{1};
filename  = [dest_cell{2},'.mat'];
cd(dest_dir);
save(filename, 'data_struct');

%% SVM
% SVM_script_for_PCA(pca_vec, dat_lengths, stims);

