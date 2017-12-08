function [ pca_vec ] = plot_PCA(vecs_in_cols, label_vec_con, label_vec_sub, label_vec_stim, subj_names, stim_names)
% Runs PCA on the input which is the data vector, in columns as a mtrix.
% dat_lengths is a vector containing the number of trials per experiment

pca_vec = pca(vecs_in_cols);

% colored according to sick and healthy
figure(); hold on;  
num_con = unique(label_vec_con);
label = cell(1, length(num_con));
for ii = 1 : length(num_con)
    idx = find(label_vec_con == num_con(ii));
    scatter3(pca_vec(idx,1), pca_vec(idx,2), pca_vec(idx,3),100, label_vec_con(idx), 'Fill');
    if num_con(ii) == 0
        label{ii} = 'Healty';
    else
        label{ii} = 'Sick';
    end    
end

xlabel('coef_1');
ylabel('coef_2');
zlabel('coef_3');
legend(label(:), 'Interpreter', 'none', 'location','southeastoutside');
title('PCA map, colored according to sick and healthy');

% colored according to subjects
figure(); hold on;  
num_sub = unique(label_vec_sub);
for ii = 1 : length(num_sub)
    idx = find(label_vec_sub == num_sub(ii));
    scatter3(pca_vec(idx,1), pca_vec(idx,2), pca_vec(idx,3),100, label_vec_sub(idx), 'Fill');  
end

xlabel('coef_1');
ylabel('coef_2');
zlabel('coef_3');
legend(subj_names(:), 'Interpreter', 'none', 'location','southeastoutside');
title('PCA map, colored per subject')

% colored according to stimulation
figure(); hold on;  
num_stim = unique(label_vec_stim);
for ii = 1 : length(num_stim)
    idx = find(label_vec_stim == num_stim(ii));
    scatter3(pca_vec(idx,1), pca_vec(idx,2), pca_vec(idx,3),100, label_vec_stim(idx), 'Fill'); 
end

xlabel('coef_1');
ylabel('coef_2');
zlabel('coef_3');
legend(stim_names(:), 'Interpreter', 'none', 'location','southeastoutside');
title('PCA map, colored per stimulation')
