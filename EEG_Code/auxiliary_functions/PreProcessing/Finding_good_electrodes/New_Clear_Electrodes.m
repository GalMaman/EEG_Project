function [] = New_Clear_Electrodes(source_direct, edited_EEG_data, subj_names, stims_vec)

N               = length(subj_names);
electrodes_num  = 68;
good_electrodes = 1:electrodes_num;
                                    
for ii = 1:N
    for jj = stims_vec
        stim_src_str    = [source_direct,  '\', subj_names{ii}, '\Stim_', num2str(jj)];
        if jj > 3
            stim_dest_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_', ...
                                                num2str(jj)];
        else
            stim_dest_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_0', ...
                                                num2str(jj)];
        end
        tmp_good_elec   = New_Classify_Electrodes(stim_src_str, stim_dest_str);
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
        % delete trials
        cd([stim_str, '\bad_electrodes'])
        bad_files      = dir([stim_str, '\bad_electrodes']);
        bad_names      = {bad_files.name}.';
        bad_str        = contains(bad_names,'_trials');
        bad_trials     = load(bad_names{bad_str});
        bad_trials     = bad_trials.bad_electrodes;
        name_str       = contains(bad_names,'names');
        trials_names   = load(bad_names{name_str});
        trials_names   = trials_names.trials_names;
        bad_trials     = bad_trials(good_electrodes, :);
        is_bad_trial   = sum(bad_trials,1) > 0;   
        bad_trials_num = sum(is_bad_trial);
        ind_bad        = find(is_bad_trial);

        if (bad_trials_num > 0)
            cd([stim_str, '\clean'])
            for bb = 1: bad_trials_num
                delete(trials_names{ind_bad(bb)});
            end
        end
        allfiles = dir([stim_str, '\clean']);
        allnames = {allfiles.name}.';
        M = length(allnames);
        
        good_str   = contains(allnames,'trial');
        for kk=1:M
            if good_str(kk) == 1
                cd([stim_str, '\clean'])
                tmp_trial = load(allnames{kk});
                tmp_trial = tmp_trial.data;
                str_split = strsplit(allnames{kk},'.');
                if contains(str_split{1}, '_cutstim')   % for new data names
                    str_split = strsplit(allnames{kk},'_cutstim');
                elseif contains(str_split{1}, '_ditrend')   % for new data names
                    str_split = strsplit(allnames{kk},'_ditrend');
                end
                new_name  = [str_split{1}, '_good_elec_data.mat'];
                data_F    = tmp_trial.F;
                tmp_trial.F = data_F(good_electrodes, :);
                cd([stim_str, '\good_elec_data']);
                save(new_name, 'tmp_trial');
            end
        end
    end
end


mkdir(edited_EEG_data, 'good_elecs');
cd([edited_EEG_data,'\good_elecs']);
save('good_electrodes','good_electrodes');
save('bad_electrodes','bad_electrodes');
end
