function [new_data_cell] = creating_cov_cell(data_cell, pick_stims, pick_subj, norm_data)

new_data_cell = cell(length(pick_stims), length(pick_subj));
for ii = 1:length(pick_stims)
    for jj = 1:length(pick_subj)
        for kk = 1:length(data_cell{ii,jj})
            if norm_data == 1 
                data_cell{ii,jj}{kk,1} = (data_cell{ii,jj}{kk,1} - mean(data_cell{ii,jj}{kk,1},2)) ./ std(data_cell{ii,jj}{kk,1},[],2);
%             data_cell{ii,jj}{kk,1} = (data_cell{ii,jj}{kk,1}) - min(data_cell{ii,jj}{kk,1},[],2)) ./ (max(data_cell{ii,jj}{kk,1},[],2) - min(data_cell{ii,jj}{kk,1},[],2));
            end
            new_data_cell{ii,jj}{kk,1} = cov_of_rows( data_cell{ii,jj}{kk,1});
        end
    end
end