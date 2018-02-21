function [new_data_cell] = dataICA(data_cell, pick_stims, pick_subj)

new_data_cell = cell(length(pick_stims), length(pick_subj));
elec_num = size(data_cell{1,1}{1,1},1);
for ii = 1:length(pick_stims)
    for jj = 1:length(pick_subj)
        for kk = 1:length(data_cell{ii,jj})
            temp = rica(data_cell{ii,jj}{kk,1},elec_num);
            new_data_cell{ii,jj}{kk,1} = temp.TransformWeights';
%                 new_data_cell{ii,jj}{kk,1} = fastICA(data_cell{ii,jj}{kk,1},elec_num);
        end
    end
end
             