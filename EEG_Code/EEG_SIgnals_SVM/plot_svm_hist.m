function [success_subj] = plot_svm_hist(pca_mat, dat_lengths, full_label_struct)

num_sub      = unique(full_label_struct{2});

success_subj = zeros(length(num_sub),1);
for ii = 1 : length(num_sub)
    leave_out          = ii;
    percentage         = SVM_Classifier(pca_mat, dat_lengths, full_label_struct, leave_out, 0);
    success_subj(ii,1) = percentage;
end

figure(); ax = gca;
bar(success_subj);
ylabel('Success percentage','interpreter','latex');
xlabel('Test subject','interpreter','latex');
title('Success percentage','interpreter','latex');
set(ax,'FontSize',12)