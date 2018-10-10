function [pca_vec_rot,angles] = rotation_pca(cov_mat, full_label_struct)


num_sub      = unique(full_label_struct{2});
subj_sutruct = cell(length(num_sub) , 4);
figure;
for ii = 1 : length(num_sub)
    idx                = find(full_label_struct{2} == num_sub(ii));
    subj_sutruct{ii,1} = cov_mat(:, idx);
%     subj_sutruct{ii,2} = AlgoPCA(subj_sutruct{ii,1});
%     subj_sutruct{ii,3} = subj_sutruct{ii,2}' * subj_sutruct{ii,1};
    [subj_sutruct{ii,2},subj_sutruct{ii,3},subj_sutruct{ii,4}] = AlgoPCA(subj_sutruct{ii,1});
    plot(diag(subj_sutruct{ii,3})); hold on;
end
legend(num2str(num_sub));
angles   = zeros(length(num_sub), size(subj_sutruct{1,2},2));
sub_idx  = 1;
vSub = setdiff(1:length(num_sub), sub_idx);
for ii = vSub
    angles(ii,:)       = acosd(sum(subj_sutruct{sub_idx,2} .* subj_sutruct{ii,2}));
    vMult              = sign(sum(subj_sutruct{sub_idx,2} .* subj_sutruct{ii,2}));
    if ii == 3
%         angle = acosd(sum(subj_sutruct{sub_idx,2} .* subj_sutruct{ii,2}));
        vMult(2) = -1 * vMult(2);
    elseif ii == 5
        vMult(1) = -1 * vMult(1);
        vMult(2) = -1 * vMult(2);
%     elseif ii == 6 
%         vMult(2) = -1 * vMult(2);  
%     elseif ii == 8 
%         vMult(1) = -1 * vMult(1);
%         vMult(2) = -1 * vMult(2);
%     elseif ii == 10
%         vMult(2) = -1 * vMult(2);
    end
        
            
    subj_sutruct{ii,2} = subj_sutruct{ii,2} .* vMult;
end


% ang_mat = zeros(length(num_sub),length(num_sub) + 1,size(cov_mat,1));
% vMult   = ones(size(cov_mat,1),length(num_sub));
% for ii = 1:length(num_sub)
%     for jj = ii + 1 : length(num_sub)
%        ang_mat(ii,jj,:) = abs(acosd(sum(subj_sutruct{ii,2} .* subj_sutruct{jj,2})));
%        ang_mat(jj,ii,:) = ang_mat(ii,jj,:);
%     end
% 	ang_mat(ii,length(num_sub)+1,:) = max(ang_mat(ii,1:length(num_sub),:));
% end
% [~,id] = min(ang_mat(:,length(num_sub)+1,:));
% 
% for ii = 1:size(cov_mat,1)
%     isub        = id(1,1,ii);
%     vMult(ii,:) = ang_mat(isub,1:length(num_sub),ii);
% end
% vMult(vMult==0)=eps;
% for ii = 1:length(num_sub)
%     subj_sutruct{ii,2} = subj_sutruct{ii,2} .* sign(cosd(vMult(:,ii)))';
% end

pca_vec_rot = [];
for ii = 1 : length(num_sub)
    temp    = subj_sutruct{ii,2}' * (subj_sutruct{ii,1} - mean(subj_sutruct{ii,1},2)) + mean(subj_sutruct{ii,1},2);
%     temp = subj_sutruct{ii,2}' * subj_sutruct{ii,4};
    pca_vec_rot = [pca_vec_rot temp];
end
