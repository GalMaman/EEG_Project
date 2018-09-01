function [new_data_cell] = creating_cov_cell(data_cell, pick_stims, pick_subj, norm_data)

new_data_cell = cell(length(pick_stims), length(pick_subj));
for ii = 1:length(pick_stims)
    for jj = 1:length(pick_subj)
        for kk = 1:length(data_cell{ii,jj})
            if norm_data == 1 
                data_cell{ii,jj}{kk,1} = (data_cell{ii,jj}{kk,1} - mean(data_cell{ii,jj}{kk,1},2)) ./ std(data_cell{ii,jj}{kk,1},[],2);
%                 data_cell{ii,jj}{kk,1} = (data_cell{ii,jj}{kk,1}) ./ std(data_cell{ii,jj}{kk,1},[],2);
                
            end
%             A = data_cell{ii,jj}{kk,1}(:, 1:end-1);
%             B = data_cell{ii,jj}{kk,1}(:,2:end);
%             data_cell{ii,jj}{kk,1} = [A;B];
            new_data_cell{ii,jj}{kk,1} = cov_of_rows( data_cell{ii,jj}{kk,1});
%             new_data_cell{ii,jj}{kk,1} = corrcoef(data_cell{ii,jj}{kk,1}');
        end
    end
end