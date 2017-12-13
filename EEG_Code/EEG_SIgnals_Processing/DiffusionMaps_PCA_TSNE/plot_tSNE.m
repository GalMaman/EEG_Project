function [ ] = plot_tSNE(mZ, labels, legend_cell, title_str)

figure; hold on; ax = gca;
num_of_labels = unique(labels);
for ii = 1 : length(num_of_labels)
    if size(mZ,2) == 2
        scatter(mZ(find(labels == num_of_labels(ii)) ,1), mZ(find(labels == num_of_labels(ii)),2), 100, labels(find(labels == num_of_labels(ii))), 'Fill');
    else
        scatter3(mZ(find(labels == num_of_labels(ii)),1), mZ(find(labels == num_of_labels(ii)),2), mZ(find(labels == num_of_labels(ii)),3),100, labels(find(labels == num_of_labels(ii))), 'Fill'); 
    end
end
legend(legend_cell(:),'Interpreter', 'none', 'location','southeastoutside');
title(sprintf('t-SNE map, colored according to %s', title_str),'interpreter','latex');
set(ax,'FontSize',12)
