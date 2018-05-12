pca_vec = pca_vec_rot;
title_str = 'with PT and rotation';
ax = [];
subj_names = {'C01';'C02';'C03';'C04';'C05';'C06';'C07';'C08';'C10';'C11';'C12';'S01';'S02';'S03';'S04';'S05'};
color_list = {[0 1 1];[1 0 1];[0 1 0]}; % for 3 stimulations

figure(); hold on; ax(1) = gca;
num_sub = unique(full_label_struct{2});
for ii = 1 : length(num_sub)
    idx = find(full_label_struct{2} == num_sub(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),50,full_label_struct{2}(idx), 'Marker','x','LineWidth',1.5);  
end
subj_str = subj_names(num_sub);
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(subj_str(:), 'Interpreter', 'latex', 'location','best');
title(sprintf('PCA map, colored per subject %s', title_str),'interpreter','latex');
% view(-89.46,11.92);

figure(); hold on; ax(2) = gca;
num_stim = unique(full_label_struct{3});
for ii = 1 : length(num_stim)
    idx = find(full_label_struct{3} == num_stim(ii));
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),30,'MarkerFaceColor',color_list{ii},'MarkerEdgeColor','none');; 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(full_label_struct{4}(:), 'Interpreter', 'none', 'location', 'best');
title(sprintf('PCA map, colored per stimulus %s', title_str),'interpreter','latex');
% view(-89.46,11.92);

time_vec = zeros(1800,1);
for ii = 1 : length(num_sub)
    idx_sub = find(full_label_struct{2} == num_sub(ii));
    for jj = 1 : length(num_stim)
        idx_stim = find(full_label_struct{3}(idx_sub) == num_stim(jj));
        idx_stim = idx_sub(idx_stim);
        for mm = 1:3
            idx           = idx_stim((mm - 1) * 40 + 1: mm * 40);
            time_vec(idx) =  mm + 3 * (jj - 1);
        end 
    end
end
        
figure(); hold on; ax(3) = gca;
for ii = 1 : 9
    idx = find(time_vec == ii);
    scatter3(pca_vec(1,idx), pca_vec(2,idx), pca_vec(3,idx),30,ii * ones(200,1),'filled');
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend({'1:40 somatosensory';'41:80 somatosensory';'81:120 somatosensory';...
    '1:40 visual';'41:80 visual';'81:120 visual';'1:40 auditory';...
    '41:80 auditory';'81:120 auditory'}, 'Interpreter', 'none', 'location', 'best');
title(sprintf('PCA map, colored per stimulus %s', title_str),'interpreter','latex');

linkprop(ax,{'CameraPosition','CameraUpVector'}); 