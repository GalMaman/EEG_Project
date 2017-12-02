function [new_data_cell] = creating_kernal_cell(data_cell, pick_stims, pick_subj);

new_data_cell = cell(length(pick_stims), length(pick_subj));
for ii = 1:length(pick_stims)
    for jj = 1:length(pick_subj)
        for kk = 1:length(data_cell{ii,jj})
        new_data_cell{ii,jj}{kk,1} = calculate_kernel_matrix( data_cell{ii,jj}{kk,1});
        end
    end
end