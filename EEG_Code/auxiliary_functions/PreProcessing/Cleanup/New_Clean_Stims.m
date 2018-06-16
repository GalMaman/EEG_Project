function [ output_args ] = New_Clean_Stims( source_direct, edited_EEG_data, subj_names, stims_vec )
% Recieves the Source and destination cirectories, and the subject names,
% and cleans out the data, saving it in the appropriate direc. in the
% destination. Also downsamples and cuts in special manner for
% somatosensory.

%% Regular cleanup:
N             = length(subj_names);
stim_src_str  = [];
stim_dest_str = [];
Fs            = 1000;
% Loading the band pass filter:
% load('NewBPF.mat');
load('IIR_BPF.mat');
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
        % Cleaning the data and downsampling it

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
        
        good_str   = contains(allnames,'trial');
        for kk = 1:M
            if good_str(kk) == 1
                cd(stim_src_str)
                tmp_trial   = load(allnames{kk});
                data_F = tmp_trial.F;
                data_t = tmp_trial.Time;
                % resample trial
                dnsmpl_dat = (resample(data_F',1,q))';
                dnsmpl_t   = (resample(data_t',1,q))';
                % Convolute the data with the BPF:
                dnsmpl_dat = conv2(dnsmpl_dat, BPF, 'same');
                str_split   = strsplit(allnames{kk},'.');
                if contains(str_split{1}, '_cutstim')   % for new data names
                    str_split = strsplit(allnames{kk},'_cutstim');
                elseif contains(str_split{1}, '_ditrend')   % for new data names
                    str_split = strsplit(allnames{kk},'_ditrend');
                end
                
                new_name  = [str_split{1}, '_clean.mat'];
                cd(stim_dest_str)
                clean_data = dnsmpl_dat(:,dnsmpl_t >= time_begin);
                if jj < 3
                    clean_data = clean_data(:,1:ceil(end/2));
                end
                save(new_name,'clean_data');
            end

        end
    end
end

end

