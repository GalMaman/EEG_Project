function [ Psi, Lambda ] = Diffus_map( cov_mat, full_label_struct, subj_names, title_str, dist )

N        = size (cov_mat,3);
dist_mat = zeros(N, N);

if dist == 0
    dist_mat = squareform( pdist(cov_mat') );
else
    for jj = 1 :N
        for ii = jj + 1 : N
            dist_mat(jj, ii) = RiemannianDist(cov_mat(:,:,jj), cov_mat(:,:,ii));
        end
    end
end
dist_mat = dist_mat + dist_mat';

epsilon = median(dist_mat(:));
K       = exp(-dist_mat.^2 / (2 * epsilon)^2);
P       = K ./ sum(K, 2);

[Psi, Lambda] = eig(P);


% colored according to subjects
figure(); hold on; ax(1) = gca;
num_sub = unique(full_label_struct{2});
for ii = 1 : length(num_sub)
    idx = find(full_label_struct{2} == num_sub(ii));
    scatter3(Psi(idx,2) * Lambda(2,2), Psi(idx,3) * Lambda(3,3), Psi(idx,4) * Lambda(4,4),100, full_label_struct{2}(idx), 'Fill');  
end

xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(subj_names(:), 'Interpreter', 'latex', 'location','southeastoutside');
title(sprintf('Diffusion map, colored per subject %s', title_str),'interpreter','latex');


% colored according to stimulus
figure(); hold on; ax(2) = gca;
num_stim = unique(full_label_struct{3});
for ii = 1 : length(num_stim)
    idx = find(full_label_struct{3} == num_stim(ii));
    scatter3(Psi(idx,2) * Lambda(2,2), Psi(idx,3) * Lambda(3,3), Psi(idx,4) * Lambda(4,4),100, full_label_struct{3}(idx), 'Fill'); 
end
xlabel('$\psi_1$','Interpreter','latex');
ylabel('$\psi_2$','Interpreter','latex');
zlabel('$\psi_3$','Interpreter','latex');
legend(full_label_struct{4}(:), 'Interpreter', 'none', 'location','southeastoutside');
title(sprintf('Diffusion map, colored per stimulus %s', title_str),'interpreter','latex');
set(ax,'FontSize',12);
