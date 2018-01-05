function [] = SVM_Classifier(cov_mat, dat_lengths, full_label_struct, leave_out)


[train_data, test_data]         = SVM_script_for_PCA(cov_mat', dat_lengths, full_label_struct, leave_out);

% classify without PT
% [trainedClassifier, validationAccuracy] = mediumgaussianClassifier11(train_data);
% [trainedClassifier, validationAccuracy] = SVMClassifier_rotpca(train_data);
[trainedClassifier, validationAccuracy] = cubicClassifier4DM(train_data);
data_for_training                       = test_data(:,2:end);
yfit                                    = trainedClassifier.predictFcn(data_for_training);


known_label     = test_data(:,1);
predicted_label = yfit;
known_mat       = zeros(3, length(known_label));
predicted_mat   = zeros(3, length(known_label));
for ii = 1 : 3
    known_mat(ii, known_label == ii)         = 1;
    predicted_mat(ii, predicted_label == ii) = 1;
end

plotconfusion(known_mat, predicted_mat);
ax = gca; set(gca, 'Fontsize', 12);
ax.XTickLabel = {'somatosensory', 'visual', 'audiotory',''};
ax.YTickLabel = {'somatosensory', 'visual', 'audiotory',''};
xlabel('Known Label')
ylabel('Predicted Label');
