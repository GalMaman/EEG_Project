function [new_data_cell] = choose_electrodes(data_cell, pick_stims, pick_subj, elec_array, good_elec)

idx       = [];
for ii = 1 : length(elec_array)
    idx = [idx; find(good_elec == elec_array(ii))];
end
new_data_cell = cell(length(pick_stims), length(pick_subj));
for ii = 1 : length(pick_stims)
    for jj = 1 : length(pick_subj)
        for kk = 1 : length(data_cell{ii,jj})
        new_data_cell{ii,jj}{kk,1} = data_cell{ii,jj}{kk,1}(idx,:);
        end
    end
end