clear;
clc;

%%
addpath(genpath('./'));

%% parameters
src_dir            = 'E:\EEG_Project\CleanData\edited_EEG_data';
% src_dir            = 'C:\Users\Oryair\Desktop\Workarea\EEG_Project\CleanData\edited_EEG_data';
num_of_trials      = 500; % to load all trials enter inf 

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
[ data_cell, legend_cell, label_struct ] = load_trials( pick_stims, pick_subj,subjs, src_dir,...
                                                      stims,num_of_trials, 0); % all electrodes - 0
                                                                               % 32 electrodes - 1
disp('    --finished loading all trials');
toc
norm_data = 1;

%% finding good electrodes
load bad_elec_subj.mat
good_elec   = find(sum(hist_sub(:,pick_subj),2) == 0);

%% choose best electrodes
tic;
elec_num   = 1;
[comb_vecs, elec_score] = choose_optimal_electrodes(data_cell, label_struct, pick_stims, pick_subj, good_elec, elec_num);
disp('    --found optimal electrodes');
toc

[sorted_vecs,idx_vecs] = sort(elec_score,'descend');
elec_vec               = comb_vecs(idx_vecs(1), :);
score                  = elec_score(idx_vecs(1));

%% plot results
best_data_cell = creating_good_elec_cell(data_cell, pick_stims, pick_subj, elec_vec);
if length(pick_subj) == 1
	best_data_cell                              = creating_cov_cell(best_data_cell, pick_stims, pick_subj,0);
    [cov_3Dmat, dat_lengths, full_label_struct] = CellToMat3D(best_data_cell,label_struct); 
    [best_mat, ~]                               = cov2vec(cov_3Dmat);
    [U]                                         = AlgoPCA(best_mat);
    pca_vec                                     = U' * best_mat;
    [ax]                                        = plot_PCA(pca_vec, full_label_struct, []);
    linkprop(ax ,{'CameraPosition','CameraUpVector'}); 
else
    best_data_cell                              = creating_cov_cell(best_data_cell, pick_stims, pick_subj,1);
    [cov_3Dmat, dat_lengths, full_label_struct] = CellToMat3D(best_data_cell,label_struct); 
    [cov_mat_PT, ~]                             = Parallel_Tranport(cov_3Dmat);
    [best_mat]                                  = rotation_pca(cov_mat_PT, full_label_struct);
    [ax]                                        = plot_PCA(best_mat, full_label_struct, 'with PT and rotation');
    linkprop(ax ,{'CameraPosition','CameraUpVector'});
end

%%
plot_electrodes_cap(elec_vec,good_elec,elec_score);

%% 
allelecs4 = zeros(68,1);
allelecs4(comb_vecs)   = elec_score;

%% bar
figure;
score_per_subj = [allelecs1 allelecs2 allelecs3 allelecs4];
bar(score_per_subj,'stacked');
ylabel('Success Percentage','interpreter','latex');
xlabel('Electrode Number','interpreter','latex');
title('Electrodes Score','interpreter','latex');
legend([{'C01'};{'C02'};{'C03'};{'C04'}],'interpreter','latex');

figure;
imagesc(score_per_subj); colorbar; colormap('spring');
title('Electrodes Score','interpreter','latex');