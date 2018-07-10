function [] = Clear_Electrodes_V2(edited_EEG_data, subj_names, stims_vec)

N               = length(subj_names);
electrodes_num  = 68;
good_electrodes = 1:electrodes_num;
                                    
for ii = 1:N
    for jj = stims_vec
        if jj > 3
            stim_src_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_', ...
                                                num2str(jj)];
        else
            stim_src_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_0', ...
                                                num2str(jj)];
        end
        tmp_good_elec   = Classify_Electrodes_V2(stim_src_str);
        good_electrodes = intersect(good_electrodes, tmp_good_elec);
    end
end

bad_electrodes = setdiff(1:electrodes_num, good_electrodes);
     
for ii = 1:N
    for jj = stims_vec
        if jj > 3
            stim_str    = [edited_EEG_data, '\', subj_names{ii}, '\Stim_', ...
                                                num2str(jj)];
        else
            stim_str    = [edited_EEG_data, '\', subj_names{ii}, '\Stim_0', ...
                                                num2str(jj)];
        end
        allfiles = dir([stim_str, '\clean']);
        allnames = {allfiles.name}.';
        M        = length(allnames);
        good_str = contains(allnames,'trial');
        for kk=1:M
            if good_str(kk) == 1
                cd([stim_str, '\clean'])
                tmp_trial = load(allnames{kk});
                str_split = strsplit(allnames{kk},'.');
                if contains(str_split{1}, '_cutstim')   % for new data names
                    str_split = strsplit(allnames{kk},'_cutstim');
                elseif contains(str_split{1}, '_ditrend')   % for new data names
                    str_split = strsplit(allnames{kk},'_ditrend');
                end
                new_name  = [str_split{1}, '_good_data.mat'];
                field     = fieldnames(tmp_trial);
                tmp_trial = getfield(tmp_trial, field{1});
                good_data = tmp_trial(good_electrodes, :);
                cd([stim_str, '\good_data']);
                save(new_name, 'good_data');
            end
        end
    end
end


mkdir(edited_EEG_data, 'good_elecs');
cd([edited_EEG_data,'\good_elecs']);
save('good_electrodes','good_electrodes');
save('bad_electrodes','bad_electrodes');
end
