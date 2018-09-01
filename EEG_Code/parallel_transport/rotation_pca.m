function [pca_vec_rot] = rotation_pca(cov_mat, full_label_struct)


num_sub      = unique(full_label_struct{2});
subj_sutruct = cell(length(num_sub) , 4);
for ii = 1 : length(num_sub)
    idx                = find(full_label_struct{2} == num_sub(ii));
    subj_sutruct{ii,1} = cov_mat(:, idx);
%     subj_sutruct{ii,2} = AlgoPCA(subj_sutruct{ii,1});
%     subj_sutruct{ii,3} = subj_sutruct{ii,2}' * subj_sutruct{ii,1};
    [subj_sutruct{ii,2},subj_sutruct{ii,3},subj_sutruct{ii,4}] = AlgoPCA(subj_sutruct{ii,1});
end


sub_idx  = 1;
vSub = setdiff(1:length(num_sub), sub_idx);
for ii = vSub
%     theta              = acosd(sum(subj_sutruct{sub_idx,2} .* subj_sutruct{ii,2}));
%     vMult              = sign(cosd(fix(theta)));
%     vMult(vMult == 0)  = 1;
    vMult              = sign(sum(subj_sutruct{sub_idx,2} .* subj_sutruct{ii,2}));
    subj_sutruct{ii,2} = subj_sutruct{ii,2} .* vMult;
end


pca_vec_rot = [];
for ii = 1 : length(num_sub)
%     temp    = subj_sutruct{ii,2}' * (subj_sutruct{ii,1} - mean(subj_sutruct{ii,1},2)) + mean(subj_sutruct{ii,1},2);
    temp = subj_sutruct{ii,2}' * subj_sutruct{ii,4};
    pca_vec_rot = [pca_vec_rot temp];
end
