function [percentage] = SVM_Classifier(cov_mat,dat_lengths, full_label_struct, leave_out, toplot)


[PCA_matrix, train_data, test_data, idx_test] = SVM_script_for_PCA(cov_mat', dat_lengths, full_label_struct, leave_out,1);



% [trainedClassifier, ~] = boost4_trainClassifier(train_data);
% [trainedClassifier, ~] = bagged4trainClassifier(train_data);
% [trainedClassifier, ~] = linear4_trainClassifier(train_data);
% [trainedClassifier, ~] = CoarseTree4trainClassifier(train_data);
% [trainedClassifier, ~] = SVMlinear5subjtrainClassifier(train_data);
% [trainedClassifier, ~] = LDA_7_trainClassifier(train_data);
% [trainedClassifier, ~] = Boost7_trainClassifier(train_data);
% [trainedClassifier, ~] = LinSVM7trainClassifier(train_data);
[trainedClassifier, ~] = LinSVM_8Subj_trainClassifier(train_data);
data_for_testing = test_data(:,2:end);
yfit              = trainedClassifier.predictFcn(data_for_testing);



known_label     = test_data(:,1);
predicted_label = yfit;
c_mat           = confusionmat(known_label, predicted_label);
percentage      = 100 * trace(c_mat) / sum(c_mat(:));
if toplot == 1
    known_mat     = zeros(3, length(known_label));
    predicted_mat = zeros(3, length(known_label));
    for ii = 1 : 3
        known_mat(ii, known_label == ii)         = 1;
        predicted_mat(ii, predicted_label == ii) = 1;
    end
    figure();
    plotconfusion(known_mat, predicted_mat);
    ax = gca; set(gca, 'Fontsize', 12);
    ax.XTickLabel = {'somatosensory', 'visual', 'audiotory',''};
    ax.YTickLabel = {'somatosensory', 'visual', 'audiotory',''};
    xlabel('Known Label')
    ylabel('Predicted Label');
    
    % decision ares
    data            = PCA_matrix(:,2:end);
    mMean           = mean(data, 1);
    [coeff, score]  = pca(data);
    d               = 0.6; 
    [X1, X2, X3]    = meshgrid(min(score(:,1)):d:max(score(:,1)),min(score(:,2)):d:max(score(:,2)), min(score(:,3)):d:max(score(:,3)));
    mTest           = [X1(:), X2(:), X3(:)];
    projected_mTest = mTest * coeff(:,1:3)';
    projected_mTest = bsxfun(@plus, projected_mTest, mMean);
    vP              = trainedClassifier.predictFcn(projected_mTest);
    
    figure; hold on; ax = gca;
%     plot3(score(idx_test,1), score(idx_test,2),score(idx_test,3),'mo','Linewidth',3,'MarkerSize',8);
    for ii = 1 : 3
        idx = find(vP(:) == ii);
        scatter3(mTest(idx,1), mTest(idx,2), mTest(idx,3), 8, vP(idx), 'Fill');
    end
    for ii = 1 : 3
        idx = find(PCA_matrix(:,1) == ii);
        scatter3(score(idx,1), score(idx,2),score(idx,3), 60, PCA_matrix(idx,1), 'Fill','MarkerEdgeColor','k'); 
    end
    
    xlabel('$\psi_1$','Interpreter','latex');
    ylabel('$\psi_2$','Interpreter','latex');
    zlabel('$\psi_3$','Interpreter','latex');
%     legend([{'tested subject'},{'somatosensory'}, {'visual'}, {'auditory'}], 'Interpreter', 'latex');
    legend([{'somatosensory'}, {'visual'}, {'auditory'}], 'Interpreter', 'latex');
%     title('Decision ares'); 
    set(ax,'FontSize',12)
    xlim([min(score(:,1)) max(score(:,1))]);
    ylim([min(score(:,2)) max(score(:,2))]);
    zlim([min(score(:,3)) max(score(:,3))]);
    hold off
end

