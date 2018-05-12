function [comb_vecs, elec_score] = choose_optimal_electrodes(data_cell, label_struct, pick_stims, pick_subj, good_elec, elec_num)

comb_vecs  = nchoosek(good_elec, elec_num);
num_comb   = size(comb_vecs, 1);
elec_score = zeros(num_comb,1);

for ii = 1 : num_comb
    test_elec      = comb_vecs(ii, :);
    test_data_cell = creating_good_elec_cell(data_cell, pick_stims, pick_subj, test_elec);
    if length(pick_subj) == 1
        test_data_cell                              = creating_cov_cell(test_data_cell, pick_stims, pick_subj,0);
        [cov_3Dmat, dat_lengths, full_label_struct] = CellToMat3D(test_data_cell,label_struct); 
        [test_mat, ~]                               = cov2vec(cov_3Dmat);
    else
        test_data_cell                              = creating_cov_cell(test_data_cell, pick_stims, pick_subj,1);
        [cov_3Dmat, dat_lengths, full_label_struct] = CellToMat3D(test_data_cell,label_struct); 
        [cov_mat_PT, ~]                             = Parallel_Tranport(cov_3Dmat);
        [test_mat]                                  = rotation_pca(cov_mat_PT, full_label_struct);
    end
    
    elec_score(ii) = calculate_elec_score(test_mat, dat_lengths, full_label_struct);
end

