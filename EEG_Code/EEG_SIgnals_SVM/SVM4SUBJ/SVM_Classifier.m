function [percentage] = SVM_Classifier(cov_mat, dat_lengths, full_label_struct, leave_out, toplot)


[PCA_matrix, train_data, test_data, idx_test] = SVM_script_for_PCA(cov_mat', dat_lengths, full_label_struct, leave_out,1);



% [trainedClassifier, ~] = boost4_trainClassifier(train_data);
% [trainedClassifier, ~] = bagged4trainClassifier(train_data);
% [trainedClassifier, ~] = linear4_trainClassifier(train_data);
% [trainedClassifier, ~] = CoarseTree4trainClassifier(train_data);
[trainedClassifier, ~] = Fine3trainClassifier(train_data);
% [trainedClassifier, ~] = LDA_7_trainClassifier(train_data);
% [trainedClassifier, ~] = Boosted_7_trainClassifier(train_data);
% [trainedClassifier, ~] = Linear_SVM_7_trainClassifier(train_data);
% [trainedClassifier, ~] = Boosted_new_cov_trainClassifier(train_data);
data_for_training                       = test_data(:,2:end);
yfit                                    = trainedClassifier.predictFcn(data_for_training);


known_label     = test_data(:,1);
predicted_label = yfit;
c_mat           = confusionmat(known_label, predicted_label);

percentage = 100 * trace(c_mat) / sum(c_mat(:));
if toplot == 1
    known_mat       = zeros(3, length(known_label));
    predicted_mat   = zeros(3, length(known_label));
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

    [coeff, score]  = pca(PCA_matrix(:,2:end));
    d               = 0.8; 
    [X1, X2, X3]    = meshgrid(min(PCA_matrix(:,2)):d:max(PCA_matrix(:,2)),min(PCA_matrix(:,3)):d:max(PCA_matrix(:,3)), min(PCA_matrix(:,4)):d:max(PCA_matrix(:,4)));
    mTest           = [X1(:), X2(:), X3(:)];
    projected_mTest =  coeff(:,1:3) * mTest';
    vP              = trainedClassifier.predictFcn(projected_mTest');
    
    figure; hold on; ax = gca;
    plot3(PCA_matrix(idx_test,2), PCA_matrix(idx_test,3),PCA_matrix(idx_test,4),'mo','Linewidth',3,'MarkerSize',8);
    for ii = 1 : 3
        idx = find(vP(:) == ii);
        scatter3(mTest(idx,1), mTest(idx,2), mTest(idx,3), 8, vP(idx), 'Fill');
    end
    for ii = 1 : 3
        idx = find(PCA_matrix(:,1) == ii);
        scatter3(PCA_matrix(idx,2), PCA_matrix(idx,3),PCA_matrix(idx,4), 60, PCA_matrix(idx,1), 'Fill','MarkerEdgeColor','k'); 
    end
    
    xlabel('$\psi_1$','Interpreter','latex');
    ylabel('$\psi_2$','Interpreter','latex');
    zlabel('$\psi_3$','Interpreter','latex');
    legend([{'tested subject'},{'somatosensory'}, {'visual'}, {'auditory'}], 'Interpreter', 'latex');
    title('Decision ares'); 
    set(ax,'FontSize',10)
    xlim([min(PCA_matrix(:,2)) max(PCA_matrix(:,2))]);
    ylim([min(PCA_matrix(:,3)) max(PCA_matrix(:,3))]);
    zlim([min(PCA_matrix(:,4)) max(PCA_matrix(:,4))]);
    hold off
end

