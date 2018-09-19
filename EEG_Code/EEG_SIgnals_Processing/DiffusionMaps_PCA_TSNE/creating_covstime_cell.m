function [new_data_cell] = creating_covstime_cell(data_cell, pick_stims, pick_subj, norm_data)

new_data_cell = cell(length(pick_stims), length(pick_subj));
for ii = 1:length(pick_stims)
    for jj = 1:length(pick_subj)
        for kk = 1:length(data_cell{ii,jj})
            if norm_data == 1 
                data_cell{ii,jj}{kk,1} = (data_cell{ii,jj}{kk,1} - mean(data_cell{ii,jj}{kk,1},2)) ./ std(data_cell{ii,jj}{kk,1},[],2);
            end
%             elec_mat = calculate_elec_cov(data_cell{ii,jj}{kk,1});
            elec_mat  = calculate_elec_spectrogram(data_cell{ii,jj}{kk,1});
            dist_mat  = calculate_dist_mat(elec_mat);
            epsilon   = median(dist_mat(:));
            new_data_cell{ii,jj}{kk,1} = exp(-dist_mat / (2 * epsilon));
        end
    end
end