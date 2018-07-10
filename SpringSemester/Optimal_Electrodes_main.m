clear;
clc;

%%
addpath(genpath('./'));

%% parameters
% src_dir       = 'E:\EEG_Project\CleanData\edited_EEG_data';
src_dir       = 'E:\EEG_Project\GoodData\edited_EEG_data';
% src_dir     = 'C:\Users\Oryair\Desktop\Workarea\EEG_Project\CleanData\edited_EEG_data';
num_of_trials = 50; % to load all trials enter inf 

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

%% finding good electrodes
load BadElectrodes.mat
good_elec   = find(sum(hist_sub(:,pick_subj),2) == 0);
% load(['E:\EEG_Project\NewData2\edited_EEG_data\good_elecs\good_electrodes.mat']);

% good_elec = good_electrodes;

%% choose best electrodes
tic;
elec_num = 1;
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
%     best_data_cell                              = creating_fourier_cell(best_data_cell, pick_stims, pick_subj,1:100);
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
if elec_num > 1
    plot_electrodes_cap(elec_vec,good_elec);
else
    plot_electrodes_cap(elec_vec,good_elec,elec_score);
end

%% plot for 2 electrodes
N_vecs = 10;
str    = strcat(string(comb_vecs(idx_vecs(1:N_vecs),1)),',',string(comb_vecs(idx_vecs(1:N_vecs),2)));
figure; ax = gca;
scatter3(comb_vecs(idx_vecs(1:N_vecs),1), comb_vecs(idx_vecs(1:N_vecs),2), elec_score(idx_vecs(1:N_vecs)), 50, elec_score(idx_vecs(1:N_vecs)),'filled');
hold on; textscatter3(comb_vecs(idx_vecs(1:N_vecs),1)+0.2, comb_vecs(idx_vecs(1:N_vecs),2)+0.2,...
    elec_score(idx_vecs(1:N_vecs))+0.4 ,str ,'TextDensityPercentage',90);
xlim([1 68]);
ylim([1 68]);
title([num2str(N_vecs) ' best combinations'],'Interpreter','latex');
xlabel('electrode 1','Interpreter','latex');
ylabel('electrode 2','Interpreter','latex');
zlabel('score','Interpreter','latex');
set(ax,'FontSize',12);

score_mat = zeros(68);
for ii = 1:size(comb_vecs,1)
    score_mat(comb_vecs(ii,1), comb_vecs(ii,2)) = elec_score(ii,1);
    score_mat(comb_vecs(ii,2), comb_vecs(ii,1)) = elec_score(ii,1);
end

tick_vec = 1:5:68;
figure; 
imagesc(score_mat);
colorbar;
title(sprintf('Subject %s - score results', subjs{pick_subj}),'Interpreter','latex');
xlabel('electrode 1','Interpreter','latex');
ylabel('electrode 2','Interpreter','latex');
set(gca, 'XTick', tick_vec);
set(gca, 'XTickLabel', tick_vec);
set(gca, 'YTick', tick_vec);
set(gca, 'YTickLabel', tick_vec);
set(gca,'FontSize',14);

%% 
score_per_subj = [];

%%
allelecs = zeros(68,1);
allelecs(comb_vecs)   = elec_score;
score_per_subj = [score_per_subj allelecs];

%%
avg_score           = mean(score_per_subj,2);
[best_avg,best_idx] = max(avg_score);
plot_electrodes_cap(best_idx,1:68,avg_score);


%% bar
figure;
% score_per_subj = [allelecs1 allelecs2 allelecs3 allelecs4];
bar(score_per_subj,'stacked');
ylabel('Success Percentage','interpreter','latex');
xlabel('Electrode Number','interpreter','latex');
title('Electrodes Score','interpreter','latex');
% legend([{'C01'};{'C02'};{'C03'};{'C04'}],'interpreter','latex');
legend(subjs{12:end},'interpreter','latex');

figure;
imagesc(score_per_subj); colorbar; colormap('spring');
title('Electrodes Score','interpreter','latex');
set(gca,'XTick',1:5);