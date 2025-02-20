function [pca_mat, ax] = plot_PCA_rot(cov_mat, full_label_struct, subj_names)



% colored according to subjects
figure(); hold on; ax(1) = gca;
for ii = 1 : length(num_sub)
    idx = find(full_label_struct{2} == num_sub(ii));
    scatter3(pca_mat(1,idx), pca_mat(2,idx), pca_mat(3,idx),100, full_label_struct{2}(idx), 'Fill');  
end

xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(subj_names(:), 'Interpreter', 'latex', 'location','southeastoutside');
title(sprintf('PCA map, colored per subject after PT, with rotation'),'interpreter','latex');


% colored according to stimulus
figure(); hold on; ax(2) = gca;
num_stim = unique(full_label_struct{3});
for ii = 1 : length(num_stim)
    idx = find(full_label_struct{3} == num_stim(ii));
    scatter3(pca_mat(1,idx), pca_mat(2,idx), pca_mat(3,idx),100, full_label_struct{3}(idx), 'Fill'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(full_label_struct{4}(:), 'Interpreter', 'none', 'location','southeastoutside');
title(sprintf('PCA map, colored per stimulus after PT, with rotation'),'interpreter','latex');

% colored according to stimulus type
label_stimulus_type(find(full_label_struct{3} < 3))  = 1;
label_stimulus_type(find(full_label_struct{3} == 3)) = 2;
label_stimulus_type(find(full_label_struct{3} > 3))  = 3;

figure(); hold on; ax(3) = gca;
type_str = {'somatosensory', 'visual', 'auditory'};
num_type = unique(label_stimulus_type);
type_str = type_str(num_type);
for ii = 1 : length(num_type)
    idx = find(label_stimulus_type == num_type(ii));
    scatter3(pca_mat(1,idx), pca_mat(2,idx), pca_mat(3,idx),100, label_stimulus_type(idx), 'Fill'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(type_str(:), 'Interpreter', 'latex', 'location','southeastoutside');
title(sprintf('PCA map, colored per stimulus type after PT, with rotation'),'interpreter','latex');
set(ax,'FontSize',12)
