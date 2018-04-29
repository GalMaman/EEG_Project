function [new_data_cell] = creating_PLV_cell(data_cell, pick_stims, pick_subj, norm_data)

new_data_cell = cell(length(pick_stims), length(pick_subj));
num_channels  = size(data_cell{1,1}{1,1},1);
vec_channels  = combvec(1:num_channels, 1:num_channels);

for ii = 1:length(pick_stims)
    for jj = 1:length(pick_subj)
        for kk = 1:length(data_cell{ii,jj})
            if norm_data == 1 
                data_cell{ii,jj}{kk,1} = (data_cell{ii,jj}{kk,1} - mean(data_cell{ii,jj}{kk,1},2)) ./ std(data_cell{ii,jj}{kk,1},[],2);
            end
            temp = zeros(num_channels,num_channels);
            for mm = 1:size(vec_channels,2)
                idx1 = vec_channels(1,mm);
                idx2 = vec_channels(2,mm);
                temp(idx1,idx2) = calculate_PLV(data_cell{ii,jj}{kk,1}(idx1,:),data_cell{ii,jj}{kk,1}(idx2,:));
            end
            new_data_cell{ii,jj}{kk,1} = temp * temp';
%             new_data_cell{ii,jj}{kk,1} = temp;

        end
    end
end