function [ ] = Clean_Stims_V2( source_direct, edited_EEG_data, subj_names, stims_vec )

N   = length(subj_names);
Fs  = 1000;
for ii = 1:N
    for jj = stims_vec
        stim_src_str  = [source_direct,  '\', subj_names{ii}, '\Stim_', num2str(jj)];
        if jj > 3
            stim_dest_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_', ...
                                                num2str(jj), '\clean'];
        else
            stim_dest_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_0', ...
                                                num2str(jj), '\clean'];
        end
        allfiles = dir(stim_src_str);
        allnames = {allfiles.name}.';
        M = length(allnames);
        % beginning time:
        if jj < 3
            time_begin = 0.07;
            q          = 5000/Fs;
        else
            time_begin = 0;
            q          = 1000/Fs;
        end
        
        good_str = contains(allnames,'trial');
        for kk = 1:M
            if good_str(kk) == 1
                cd(stim_src_str)
                tmp_trial   = load(allnames{kk});
                data_F      = tmp_trial.F;
                data_t      = tmp_trial.Time;
                % resample trial
                dnsmpl_dat = (resample(data_F',1,q))';
                dnsmpl_t   = (resample(data_t',1,q))';
                % Convolute the data with the BPF:
%                 vB          = [1, -1];
%                 vA          = [1, -0.97];
%                 dnsmpl_dat  = filter(vB, vA, dnsmpl_dat')';
                str_split   = strsplit(allnames{kk},'.');
                if contains(str_split{1}, '_cutstim')   % for new data names
                    str_split = strsplit(allnames{kk},'_cutstim');
                elseif contains(str_split{1}, '_ditrend')   % for new data names
                    str_split = strsplit(allnames{kk},'_ditrend');
                end
                
                new_name   = [str_split{1}, '_clean.mat'];
                clean_data = dnsmpl_dat(:,dnsmpl_t >= time_begin);
                cd(stim_dest_str)
                if jj < 3
                    clean_data = clean_data(:,1:floor(end/2));
                end
                save(new_name,'clean_data');
            end

        end
    end
end

end

