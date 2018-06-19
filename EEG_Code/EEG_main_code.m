clear;
clc;

%%
addpath(genpath('./'));

%% entering the 'edited_EEG_data' directory
% example in Gal's:     E:\EEG_Project\CleanData\edited_EEG_data

%% parameters
% src_dir = 'E:\EEG_Project\CleanData\edited_EEG_data'; % old data
% src_dir = 'E:\EEG_Project\CleanIIR\edited_EEG_data'; % IIR filtered
% src_dir = 'E:\EEG_Project\FinalCleanData\edited_EEG_data'; % with IIR
src_dir = 'E:\EEG_Project\NewData2\edited_EEG_data';
% src_dir = 'E:\EEG_Project\DataNoFilter\edited_EEG_data';
% src_dir = 'E:\EEG_Project\NewCleanData\edited_EEG_data'; % FIR filtered
% src_dir            = 'C:\Users\Oryair\Desktop\Workarea\EEG_Project\CleanData\edited_EEG_data';
choose_elec_param  = 1;
add_elec_param     = 1;
covariance_param   = 1; %choose covariance -or- kernel!
kernel_param       = 1;
Fourier_param      = 1;
PT_param           = 1;
no_PT_param        = 1;
pca_param          = 1;
rot_param          = 1;
tSNE_param         = 1;
diff_euc_param     = 1;
diff_riem_param    = 0;
tSNE_diffMap_param = 0;
num_of_trials      = 50; % to load all trials enter inf 
svm_param          = 0;

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
[load_data_cell, legend_cell, label_struct] = load_trials( pick_stims, pick_subj,subjs, src_dir,...
                                                      stims,num_of_trials, 1); % all electrodes - 0
                                                                               % 32 electrodes - 1
disp('    --finished loading all trials');
toc
% norm_data = 1;


% load bad_elec_subj.mat
% good_elec = find(sum(hist_sub,2) == 0);
% load bad_elecs.mat
% good_elec2 = find(sum(hist_sub(:,1:11),2) == 0);
% good_elec = intersect(good_elec1,good_elec2);
% load_data_cell = creating_good_elec_cell(load_data_cell, pick_stims, pick_subj, good_elec);

%% ICA
[data_cell] = dataICA(load_data_cell, pick_stims, pick_subj);
disp('    --finished ICA');
toc

%% pick electrodes
all_elec = 1:68;
elec_array = [5,28,46,50];
% elec_array  = [2;4;5;6;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32;35;36;37;38;39;40;41;42;44;45;46;47;48;49;50;51;52;53;54;55;56;57;58;59;60;61;62;63;64;67;68];
% elec_array = [4, 14, 26, 41, 53];
% good_elec = [4;5;6;8;9;10;11;12;13;14;17;18;20;21;26;27;30;35;36;37;39;40;41;44;45;50;51;53;55;57;58;59];
if choose_elec_param == 1
    [data_cell] = choose_electrodes(data_cell, pick_stims, pick_subj, elec_array,all_elec);
end

%% FFT 
n_fourier = 50;
if Fourier_param == 1
    [data_cell] = creating_fourier_cell(load_data_cell, pick_stims, pick_subj,1:100);
%     [data_cell] = creating_fourier_cell(data_cell, pick_stims, pick_subj, n_fourier);
    disp('    --finished calculating fourier matrices');
    toc
    norm_data = 0;
end
%% calculate PLV
[data_cell] = creating_PLV_cell(load_data_cell, pick_stims, pick_subj,norm_data);
disp('    --finished calculating PLV matrices');
toc

%% calculate covariance matrices
norm_data = 0;
if covariance_param == 1
    [data_cell] = creating_cov_cell(load_data_cell, pick_stims, pick_subj,norm_data);
    disp('    --finished calculating covariance matrices');
    toc
end

%%
[data_cell] = creating_covstime_cell(load_data_cell, pick_stims, pick_subj,0);
disp('    --finished calculating covariance matrices');
toc
    
%% calculate kernel matrices
if kernel_param == 1
    [data_cell] = creating_kernal_cell(load_data_cell, pick_stims, pick_subj);
    disp('    --finished calculating kernel matrices');
    toc
end

%% labels struct
[cov_3Dmat, dat_lengths, full_label_struct] = CellToMat3D(data_cell,label_struct);
disp('    --finished data matrix');
toc

%% changing covs to matrices around common mean 
if no_PT_param == 1
    [cov_mat, covs_3D] = cov2vec(cov_3Dmat);
                                    % the matrix of cov-vectors                               
    disp('    --found Riemanien mean');
    toc
end

%% Parallel Transport
% if PT_param == 1
%     [cov_mat_PT, covs_3D_PT] = Parallel_Tranport(cov_3Dmat);
%     disp('    --found Riemanien mean with PT');
%     toc
% end
%%
[cov_mat_PT_N, Riemannian_3Dmat] = NEW_Parallel_Tranport(cov_3Dmat);
disp('    --found Riemanien mean with PT');
toc

%% mean transport
[cov_mat_mean] = Mean_Tranport(cov_3Dmat);
disp('    --found Riemanien mean with MT');

%% Running PCA on the Riemannian vectors
ax1     = [];
[U]     = AlgoPCA(cov_mat);
pca_vec = U' * cov_mat;
if (pca_param == 1)&&(no_PT_param == 1)
    [ ax ] = plot_PCA(pca_vec, full_label_struct, []);
    linkprop(ax,{'CameraPosition','CameraUpVector'}); 
    disp('    --finished PCA');
    toc
end

%% PCA PT
if (pca_param == 1)&&(PT_param == 1)
    [U]        = AlgoPCA(cov_mat_PT_N);
    pca_vec_PT = U' * cov_mat_PT_N;
    [ax1]       = plot_PCA(pca_vec_PT, full_label_struct, 'with PT');
    linkprop(ax1,{'CameraPosition','CameraUpVector'});
    disp('    --finished PCA');
    toc
end

%% PCA MT
[U]        = AlgoPCA(cov_mat_mean);
pca_vec_MT = U' * cov_mat_mean;
ax         = plot_PCA(pca_vec_MT, full_label_struct, 'with Mean Transport');
linkprop([ax],{'CameraPosition','CameraUpVector'});
disp('    --finished PCA');
toc

%% pca per subject (rotation) with PT
if rot_param == 1
    [pca_vec_rot] = rotation_pca(cov_mat_PT_N, full_label_struct);
    [ax2]          = plot_PCA(pca_vec_rot, full_label_struct, 'with PT and rotation');
    linkprop([ax1 ax2] ,{'CameraPosition','CameraUpVector'});
end
%%
% if rot_param == 1
%     [pca_vec_rot] = rotation_pca(cov_mat_mean, full_label_struct);
%     [ax]          = plot_PCA(pca_vec_rot, full_label_struct, 'with PT and rotation');
%     linkprop(ax ,{'CameraPosition','CameraUpVector'});
% end

%% SVM histogram
success_subj_ROT = plot_svm_hist(pca_vec_rot, dat_lengths, full_label_struct);
disp('    --finished SVM Histogram');
toc


%% SVM histogram
success_subj_PT = plot_svm_hist(cov_mat_PT_N, dat_lengths, full_label_struct);
disp('    --finished SVM Histogram');
toc

%% SVM histogram
success_subj_mean = plot_svm_hist(cov_mat_mean, dat_lengths, full_label_struct);
disp('    --finished SVM Histogram');
toc

%% SVM histogram
success_subj_old = plot_svm_hist(cov_mat, dat_lengths, full_label_struct);
disp('    --finished SVM Histogram');
toc

%% first run
A1 = success_subj_mean;
B1 = success_subj_PT;
C1 = success_subj_ROT;
pick_subj1 = pick_subj;

%% second run
A2 = success_subj_mean;
B2 = success_subj_PT;
C2 = success_subj_ROT;
pick_subj2 = pick_subj;

%% combined for paper
mat1 = [pick_subj1' A1 B1 C1];
mat2 = [pick_subj2' A2 B2 C2];

all_clsf = [mat1 ; mat2];
all_clsf = sortrows(all_clsf);

%% paper
figure(); ax = gca;
gr_bar = [all_clsf(:,2) all_clsf(:,3) all_clsf(:,4)];
bar(gr_bar);
ylabel('Success Percentage','interpreter','latex');
xlabel('Tested Subject','interpreter','latex');
% title('Success Percentage','interpreter','latex');
legend([{'Mean Transport'};{'Parallel Transport'};{'PT and Rotation'}],'interpreter','latex');
% set(ax,'FontSize',12);
set(ax,'FontSize',16,'XTick',1 : size(all_clsf,1),'XTickLabel',...
    subjs(1:11));
ylim([0 100]);

%% plot all
figure(); ax = gca;
gr_bar = [success_subj_old success_subj_PT success_subj_ROT];
bar(gr_bar);
ylabel('Success Percentage','interpreter','latex');
xlabel('Test Subject','interpreter','latex');
% title('Success Percentage','interpreter','latex');
legend([{'Previous Work - Riemannian Geometry'};{'PT'};{'PT and Rotation'}],'interpreter','latex');
% set(ax,'FontSize',12);
set(ax,'FontSize',17,'XTick',1:size(subjs),'XTickLabel',...
   1:8);
ylim([0 100]);

%%
%% SVM histogram
success_subj_PT_N = plot_svm_hist(cov_mat_PT_N, dat_lengths, full_label_struct);
disp('    --finished SVM Histogram');
toc
%% plot all
figure(); ax = gca;
gr_bar = [success_subj_PT success_subj_PT_N];
bar(gr_bar);
ylabel('Success Percentage','interpreter','latex');
xlabel('Test Subject','interpreter','latex');
title('Success Percentage','interpreter','latex');
legend([{'PT'};{'Closed Form PT'}],'interpreter','latex');
set(ax,'FontSize',12);
% set(ax,'FontSize',12,'XTick',[1 2 3 4 5],'XTickLabel',...
%     {'C01','C02','C03','C04','C08'});
ylim([0 100]);

%% diffusion maps 
if diff_euc_param == 1
    [Psi, Lambda, ax] = Diffus_map(cov_mat, full_label_struct, subj_names, [], 0);
    linkprop(ax ,{'CameraPosition','CameraUpVector'});
    P = 30;
    diff_mat_euc  = Psi(:,2:P) * Lambda(2:P,2:P);
    figure; mZ = TSNE(diff_mat_euc , full_label_struct{3}, 2, [], 20);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects, after diffusion maps'); % plot per subject

    % plot t-SNE stim
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus, after diffusion maps'); % plot per stimulation
    disp('    --finished t-SNE without PT,  after diffusion maps');
    toc
end

%% diffusion maps PT
if diff_euc_param == 1
%     [Psi_PT, Lambda_PT, ax] = Diffus_map(cov_mat_PT_N, full_label_struct, subj_names, 'with PT', 0);
%     linkprop(ax ,{'CameraPosition','CameraUpVector'});
%     P = 50;
%     diff_mat_euc_PT     = Psi_PT(:,2:P) * Lambda_PT(2:P,2:P);
    figure; mZ = TSNE(cov_mat_PT_N' , full_label_struct{3}, 2, [], 30);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects with PT'); % plot per subject

    % plot t-SNE stim
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus with PT'); % plot per stimulation
    disp('    --finished t-SNE with PT,  after diffusion maps');
    toc
    disp('    --finished diffusion maps');
    toc
end

%% diffusion maps PT rotation
if diff_euc_param == 1
%     [Psi_rot, Lambda_rot, ax] = Diffus_map(pca_vec_rot, full_label_struct, subj_names, 'with PT and rotation', 0);
%     linkprop(ax ,{'CameraPosition','CameraUpVector'});
%     P = 30;
%     diff_mat_euc_rot     = Psi_rot(:,2:P) * Lambda_rot(2:P,2:P);
    figure; mZ = TSNE(pca_vec_rot' , full_label_struct{3}, 2, [], 30);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects with PT, after rotation'); % plot per subject

    % plot t-SNE stim
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus with PT, after rotation'); % plot per stimulation
    disp('    --finished t-SNE with PT,  after diffusion maps');
    toc
    disp('    --finished diffusion maps');
    toc
end
%% SVM after DM
leave_out = 7;
SVM_Classifier(diff_mat_euc', dat_lengths, full_label_struct, leave_out);
%%
SVM_Classifier(diff_mat_euc_PT', dat_lengths, full_label_struct, leave_out);
%%
leave_out = 10;
SVM_Classifier(diff_mat_euc_rot', dat_lengths, full_label_struct, leave_out);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% pca visualization
[cov_2D_struct] = CellToMat2D(cov_3Dmat);
[U]             = AlgoPCA(cov_2D_struct{1});
mU              = U(:,1:3);
pca_cov         = cell(1, size(cov_2D_struct,2));
pca_cov_mat     = [];
for ii = 1 : size(cov_2D_struct,2)
    pca_cov{ii} = mU' * cov_2D_struct{ii};
    pca_cov_mat = [pca_cov_mat pca_cov{ii}];
end

figure(); hold on; ax(1) = gca;
num_sub = unique(full_label_struct{2});
for ii = 1 : length(num_sub)
    idx = find(full_label_struct{2} == num_sub(ii));
    scatter3(pca_cov_mat(1,idx), pca_cov_mat(2,idx), pca_cov_mat(3,idx),100, full_label_struct{2}(idx), 'Fill');  
end

xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(subj_names(:), 'Interpreter', 'latex', 'location','southeastoutside');
title(sprintf('PCA map, colored per subject'),'interpreter','latex');

figure(); hold on; ax(2) = gca;
num_stim = unique(full_label_struct{3});
for ii = 1 : length(num_stim)
    idx = find(full_label_struct{3} == num_stim(ii));
    scatter3(pca_cov_mat(1,idx), pca_cov_mat(2,idx), pca_cov_mat(3,idx),100, full_label_struct{3}(idx), 'Fill'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(full_label_struct{4}(:), 'Interpreter', 'none', 'location','southeastoutside');
title(sprintf('PCA map, colored per stimulus'),'interpreter','latex');
set(ax,'FontSize',12)
linkprop(ax ,{'CameraPosition','CameraUpVector'});

%% SVM PCA

% pca_svm     = pca_vec(1:2, :);
% pca_svm_PT  = pca_vec_PT(1:2,:);
% pca_svm_rot = pca_mat_PT(1:2,:);
% arrange data for classification
leave_out                       = 1;
[train_data, test_data]         = SVM_script_for_PCA(pca_vec', dat_lengths, full_label_struct, leave_out);
[train_data_PT, test_data_PT]   = SVM_script_for_PCA(pca_vec_PT', dat_lengths, full_label_struct, leave_out);
[train_data_rot, test_data_rot] = SVM_script_for_PCA(pca_mat_PT', dat_lengths, full_label_struct, leave_out);

% classify without PT
[trainedClassifier, validationAccuracy] = SVMClassifier_rotpca(train_data);
data_for_training                       = test_data(:,2:end);
yfit                                    = trainedClassifier.predictFcn(data_for_training);
C                                       = confusionmat(test_data(:,1),yfit);
figure();heatmap(C);
% classify with PT
[trainedClassifier_PT, validationAccuracy_PT] = SVMClassifier_rotpca(train_data_PT);
data_for_training_PT                          = test_data_PT(:,2:end);
yfit_PT                                       = trainedClassifier_PT.predictFcn(data_for_training_PT);
CPT                                           = confusionmat(test_data_PT(:,1),yfit_PT);
figure();heatmap(CPT);

[trainedClassifier_rot, validationAccuracy_rot] = SVMClassifier_rotpca(train_data_rot);
data_for_training_rot                           = test_data_rot(:,2:end);
yfit_rot                                        = trainedClassifier_rot.predictFcn(data_for_training_rot);
Crot                                            = confusionmat(test_data_rot(:,1),yfit_rot);
figure();heatmap(Crot);



%%  diffusion maps with Riemannian distance 
if diff_riem_param == 1
    [Psi, Lambda] = Diffus_map(covs_3D, full_label_struct, subj_names, [], 1);
    diff_mat_riem = Psi(:,2:end) * Lambda(2:end,2:end);
    P = 50;
    figure; mZ = TSNE(diff_mat_riem(:,2:P), full_label_struct{2}, 2, [], 50);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects, after diffusion maps'); % plot per subject

    % plot t-SNE stim
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus, after diffusion maps'); % plot per stimulation
    disp('    --finished t-SNE without PT,  after diffusion maps');
    toc
end

%% diffusion maps with Riemannian distance PT
if diff_riem_param == 1
    [Psi_PT, Lambda_PT] = Diffus_map(covs_3D_PT, full_label_struct, subj_names, 'with PT', 1);
    diff_mat_riem_PT    = Psi_PT(:,2:end) * Lambda_PT(2:end,2:end);
    P = 50;
    figure; mZ = TSNE(diff_mat_riem_PT(:,2:P) , full_label_struct{2}, 2, [], 50);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects with PT, after diffusion maps'); % plot per subject

    % plot t-SNE stim
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus with PT, after diffusion maps'); % plot per stimulation
    disp('    --finished t-SNE with PT,  after diffusion maps');
    toc
    disp('    --finished diffusion maps');
    toc
end
%% t-SNE
if (tSNE_param == 1)&&(no_PT_param == 1)
    % plot t-SNE subj
    figure; mZ = TSNE(cov_mat', full_label_struct{2}, 2 , [], 50);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects'); % plot per subject
    
    % plot t-SNE stim
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus'); % plot per stimulation
    disp('    --finished t-SNE without PT');
    toc
end

%% t-SNE PT
if (tSNE_param == 1)&&(PT_param == 1)
    % plot t-SNE subj PT
    figure; mZ = TSNE(cov_mat_PT', full_label_struct{2}, 2 , [], 50);
    plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects, with PT'); % plot per subject

    % plot t-SNE stim PT
    plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus, with PT'); % plot per stimulation
    disp('    --finished t-SNE with PT');
    toc
end
%% SVM diff map
[diff_svm, ax]    = plot_PCA(diff_mat_euc', full_label_struct, subj_names, []);
[diff_svm_PT, ax] = plot_PCA(diff_mat_euc_PT', full_label_struct, subj_names, 'with PT');
diff_svm          = diff_svm(1:2, :);
diff_svm_PT       = diff_svm_PT(1:2,:);
% arrange data for classification
leave_out                     = 1;
[train_data, test_data]       = SVM_script_for_PCA(diff_svm', dat_lengths, full_label_struct, leave_out);
[train_data_PT, test_data_PT] = SVM_script_for_PCA(diff_svm_PT', dat_lengths, full_label_struct, leave_out);

% classify without PT
[trainedClassifier, validationAccuracy] = trainClassifierSVM2D(train_data);
data_for_training                       = test_data(:,2:end);
yfit                                    = trainedClassifier.predictFcn(data_for_training);
C                                       = confusionmat(test_data(:,1),yfit);
figure();heatmap(C);
% classify with PT
[trainedClassifier_PT, validationAccuracy_PT] = trainClassifierSVM2D(train_data_PT);
data_for_training_PT                          = test_data_PT(:,2:end);
yfit_PT                                       = trainedClassifier_PT.predictFcn(data_for_training_PT);
CPT                                           = confusionmat(test_data_PT(:,1),yfit_PT);
figure();heatmap(CPT);

v        = linspace(-5 * 10 ^ -3, 5 * 10 ^ -3, 100);
[X1, X2] = meshgrid(v, v);
mTest    = [X1(:), X2(:)]';
vP       = trainedClassifier.predictFcn(mTest');
type_str = {'somatosensory', 'visual', 'auditory'};
figure; hold on;
num_stim  = sort(unique(vP));
for ii = 1 : length(num_stim)
    idx = find(vP(:) == num_stim(ii));
    scatter(mTest(1,idx), mTest(2,idx), 3, vP(idx), 'Fill');
end
num_stim = sort(unique(test_data(:,1)));
for ii = 1 : length(num_stim)
    idx = find(test_data(:,1) == num_stim(ii));
    scatter(test_data(idx,2), test_data(idx,3),100, test_data(idx,1), 'Fill'); 
end
legend(type_str(:), 'Interpreter', 'latex');


%% preparing matrix for SVM train
if svm_param == 1
    leave_out = 1;
    [train_data, test_data]       = SVM_script_for_PCA(cov_mat', dat_lengths, full_label_struct, leave_out);
    [train_data_PT, test_data_PT] = SVM_script_for_PCA(cov_mat_PT', dat_lengths, full_label_struct, leave_out);
end
%% SVM
if svm_param == 1
    [trainedClassifier, validationAccuracy] = AllSVM_trainClassifier(train_data);
    data_for_training = test_data(:,2:end);
    yfit = trainedClassifier.predictFcn(data_for_training);
    C    = confusionmat(test_data(:,1),yfit);
    figure();heatmap(C);
    % plotconfusion(test_data(:,1),yfit);
end

%% SVM PT
if svm_param == 1
    [trainedClassifier_PT, validationAccuracy_PT] = AllSVM_trainClassifier(train_data_PT);
    data_for_training_PT = test_data_PT(:,2:end);
    yfit_PT = trainedClassifier_PT.predictFcn(data_for_training_PT);
    CPT     = confusionmat(test_data_PT(:,1),yfit_PT);
    figure();heatmap(CPT);
end

%% Now we'll run a diffusion map
% if (diffMap_param == 1)&&(no_PT_param == 1)
%     [ diffusion_matrix, diffusion_eig_vals, type_label ] = Diff_map( cov_mat, dat_lengths, legend_cell, full_label_struct{1});
%     disp('    --wrote down diffusion maps');
%     % diffusion_matrix =[];
%     toc
% end

%% Now we'll run a diffusion map PT
% if (diffMap_param == 1)&&(PT_param == 1)
%     [ diffusion_matrix_PT, diffusion_eig_vals_PT, type_label ] = Diff_map( cov_mat_PT, dat_lengths, legend_cell, full_label_struct{1});
%     disp('    --wrote down diffusion maps with PT');
%     % diffusion_matrix =[];
%     toc
% end

%% t-SNE on diffusion matrix
% if (tSNE_diffMap_param == 1)&&(no_PT_param == 1)
%     % plot t-SNE subj    
%     P = 20;
%     figure; mZ = TSNE(diffusion_matrix(:,2:P) * diffusion_eig_vals(2:P,2:P), full_label_struct{2}, 2, [], 50);
%     plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects, after diffusion maps'); % plot per subject
%     
%     % plot t-SNE stim
%     plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus, after diffusion maps'); % plot per stimulation
%     disp('    --finished t-SNE without PT,  after diffusion maps');
%     toc
% end
    
%% t-SNE on diffusion matrix PT  
% if (tSNE_diffMap_param == 1)&&(PT_param == 1)
%     % plot t-SNE subj PT
%     P = 20;
%     figure; mZ = TSNE(diffusion_matrix_PT(:,2:P) * diffusion_eig_vals_PT(2:P,2:P), full_label_struct{2}, 2, [], 50);
%     plot_tSNE(mZ, full_label_struct{2}, subj_names, 'subjects, with PT, after diffusion maps'); % plot per subject
%     % plot t-SNE stim PT
%     plot_tSNE(mZ, full_label_struct{3},full_label_struct{4}, 'stimulus, with PT, after diffusion maps'); % plot per stimulation    
%     disp('    --finished t-SNE with PT,  after diffusion maps');
%     toc
% end
%% SVM
leave_out = 1;
SVM_Classifier(cov_mat, dat_lengths, full_label_struct, leave_out);
%%
SVM_Classifier(cov_mat_PT, dat_lengths, full_label_struct, leave_out);

%% SVM after PCA
leave_out   = 3;
%%
pca_svm_mat = pca_vec(1:150, :);
SVM_Classifier(pca_svm_mat, dat_lengths, full_label_struct, leave_out);
%%
pca_svm_mat = pca_vec_PT(1:150, :);
SVM_Classifier(pca_svm_mat, dat_lengths, full_label_struct, leave_out);
%%
pca_svm_mat = pca_mat_PT(1:150, :);
[percentage] = SVM_Classifier(pca_svm_mat, dat_lengths, full_label_struct, leave_out, 1);

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

%%%%%%
figure(); ax = gca;
gr_bar = [success_subj_old success_subj_PT success_subj_ROT];
bar(gr_bar);
ylabel('Success percentage','interpreter','latex');
xlabel('Test subject','interpreter','latex');
title('Success percentage','interpreter','latex');
legend([{'Riemannian Geometry only'};{'Normalization and PT'},{'Normalization, PT and rotation'}],'interpreter','latex');
set(ax,'FontSize',12)
ylim([0 100]);
% bar(success_subj_norm);
