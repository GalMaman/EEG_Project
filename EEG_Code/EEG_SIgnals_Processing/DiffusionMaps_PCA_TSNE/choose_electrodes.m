function [new_data_cell] = choose_electrodes(data_cell, pick_stims, pick_subj, elec_array)

good_elec = [4;5;6;8;9;10;11;12;13;14;17;18;20;21;26;27;30;35;36;37;39;40;41;44;45;50;51;53;55;57;58;59];
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