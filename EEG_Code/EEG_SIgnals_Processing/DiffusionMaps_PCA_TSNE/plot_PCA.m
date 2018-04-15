function [ pca_vec, ax ,U] = plot_PCA(vecs_in_cols, full_label_struct, subj_names, title_str)

[U]     = AlgoPCA(vecs_in_cols);
pca_vec = U' * vecs_in_cols;

% colored according to sick and healthy
figure(); hold on; ax(1) = gca;
num_con = unique(full_label_struct{1});
label   = cell(1, length(num_con));
for ii = 1 : length(num_con)
    idx = find(full_label_struct{1} == num_con(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),100, full_label_struct{1}(idx), 'Fill');
    if num_con(ii) == 0
        label{ii} = 'Healty';
    else
        label{ii} = 'Sick';
    end    
end

xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(label(:), 'Interpreter', 'latex', 'location','southeastoutside');
title(sprintf('PCA map, colored according to sick and healthy %s', title_str),'interpreter','latex');

% colored according to subjects
figure(); hold on; ax(2) = gca;
num_sub = unique(full_label_struct{2});
for ii = 1 : length(num_sub)
    idx = find(full_label_struct{2} == num_sub(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),100, full_label_struct{2}(idx), 'Fill');  
end

xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(subj_names(:), 'Interpreter', 'latex', 'location','southeastoutside');
title(sprintf('PCA map, colored per subject %s', title_str),'interpreter','latex');


% colored according to stimulus
figure(); hold on; ax(3) = gca;
num_stim = unique(full_label_struct{3});
for ii = 1 : length(num_stim)
    idx = find(full_label_struct{3} == num_stim(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),100, full_label_struct{3}(idx), 'Fill'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(full_label_struct{4}(:), 'Interpreter', 'none', 'location','southeastoutside');
title(sprintf('PCA map, colored per stimulus %s', title_str),'interpreter','latex');

% colored according to stimulus type
label_stimulus_type(find(full_label_struct{3} < 3))  = 1;
label_stimulus_type(find(full_label_struct{3} == 3)) = 2;
label_stimulus_type(find(full_label_struct{3} > 3))  = 3;

figure(); hold on; ax(4) = gca;
type_str = {'somatosensory', 'visual', 'auditory'};
num_type = unique(label_stimulus_type);
type_str = type_str(num_type);
for ii = 1 : length(num_type)
    idx = find(label_stimulus_type == num_type(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),100, label_stimulus_type(idx), 'Fill'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(type_str(:), 'Interpreter', 'latex', 'location','southeastoutside');
title(sprintf('PCA map, colored per stimulus type %s', title_str),'interpreter','latex');
set(ax,'FontSize',12)
