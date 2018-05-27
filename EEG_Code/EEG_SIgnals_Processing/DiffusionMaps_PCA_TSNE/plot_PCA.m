function [ax] = plot_PCA(pca_vec, full_label_struct, title_str)

% color
figure_struct                                  = full_label_struct;
label_stimulus_type(full_label_struct{3} < 3)  = 1;
label_stimulus_type(full_label_struct{3} == 3) = 2;
label_stimulus_type(full_label_struct{3} > 3)  = 3;
figure_struct{4,1}                             = label_stimulus_type';

% title
figure_struct{1,2} = ['PCA map, colored according to sick and healthy ' title_str];
figure_struct{2,2} = ['PCA map, colored per subject ' title_str];
figure_struct{3,2} = ['PCA map, colored per stimulus ' title_str];
figure_struct{4,2} = ['PCA map, colored per stimulus type ' title_str];

% iterations number
figure_struct{1,3} = unique(full_label_struct{1});
figure_struct{2,3} = unique(full_label_struct{2});
figure_struct{3,3} = unique(full_label_struct{3});
figure_struct{4,3} = unique(label_stimulus_type);

% legend
condition_str      = {'Healty';'Sick'};
figure_struct{1,4} = condition_str(figure_struct{1,3} + 1);
subj_names         = {'C01';'C02';'C03';'C04';'C05';'C06';'C07';'C08';'C10';'C11';'C12';...
                     'S01';'S02';'S03';'S04';'S05'};
figure_struct{2,4} = subj_names(figure_struct{2,3});
figure_struct{3,4} = full_label_struct{4};
type_str           = {'somatosensory', 'visual', 'auditory'};
figure_struct{4,4} = type_str(figure_struct{4,3});


% str = string((1:size(pca_vec,2))');
for jj = 1 : 4
    figure(); hold on; ax(jj) = gca;
    for ii = 1 : length(figure_struct{jj,3})
        idx = find(figure_struct{jj,1} == figure_struct{jj,3}(ii));
        if size(pca_vec,1) >= 3
            scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),30, figure_struct{jj,1}(idx), 'filled');
%         textscatter3(pca_vec(1,idx)+0.03, pca_vec(2,idx)+0.03, pca_vec(3,idx)+0.01,str(idx),'TextDensityPercentage',90)
        elseif size(pca_vec,1) == 2
            plot(pca_vec(1,idx),pca_vec(2,idx));
        else
            plot(pca_vec(1,idx));
        end
    end
    xlabel('$\psi_1$','Interpreter','latex');
    ylabel('$\psi_2$','Interpreter','latex');
    if size(pca_vec,1) >= 3
        zlabel('$\psi_3$','Interpreter','latex');
    end
    legend(figure_struct{jj,4}(:), 'Interpreter', 'latex', 'location','best');
    title(sprintf(figure_struct{jj,2}),'interpreter','latex');
end

set(ax,'FontSize',12)
