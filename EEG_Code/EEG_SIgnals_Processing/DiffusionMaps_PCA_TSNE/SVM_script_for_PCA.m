function [] = SVM_script_for_PCA(pca_vec, dat_lengths, stims)

pca_labels = [];
count      = 1;
stim_vec   = [1, 2, 3, 11, 12, 13, 14, 15, 16];
idx        = 1;
for ii = 1: length(dat_lengths(:))
    pca_labels = [pca_labels ; stim_vec(idx) * ones(dat_lengths(ii),1)];
    count      = count + 1;
    idx        = idx + 1;
    if count == 10
        count = 1;
        idx   = 1;
    end
end
PCA_matrix = [pca_labels, pca_vec(:,1:3)];

figure();
hold on;
for ii = 1:9
    ind = find(pca_labels == stim_vec(ii));
    scatter3(PCA_matrix(ind,2), PCA_matrix(ind,3), PCA_matrix(ind,4), 50, pca_labels(ind), 'Fill');
end
colormap;
xlabel('coef_1');
ylabel('coef_2');
zlabel('coef_3');
legend(stims(:), 'Interpreter', 'none', 'location','southeastoutside');