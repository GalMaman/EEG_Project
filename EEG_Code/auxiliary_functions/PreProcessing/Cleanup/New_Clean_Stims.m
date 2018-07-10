function [ ] = New_Clean_Stims(edited_EEG_data, subj_names, stims_vec )

%% Regular cleanup:
N             = length(subj_names);
Fs            = 1000;
% Loading the band pass filter:
% load('NewBPF.mat');
% load('IIR_BPF.mat');
for ii = 1:N
    for jj = stims_vec
%         stim_src_str  = [source_direct,  '\', subj_names{ii}, '\Stim_', num2str(jj)];
        if jj > 3
            stim_src_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_', ...
                                                num2str(jj), '\good_elec_data'];
            stim_dest_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_', ...
                                                num2str(jj), '\new_data'];                                
        else
            stim_src_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_0', ...
                                                num2str(jj), '\good_elec_data'];
            stim_dest_str = [edited_EEG_data, '\', subj_names{ii}, '\Stim_0', ...
                                                num2str(jj), '\new_data'];                                 
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
                tmp_trial   = tmp_trial.tmp_trial;
                data_F = tmp_trial.F;
                data_t = tmp_trial.Time;
                % resample trial
                dnsmpl_dat = (resample(data_F',1,q))';
                dnsmpl_t   = (resample(data_t',1,q))';
                % Convolute the data with the BPF:
                vB = [1, -1];
                vA = [1, -0.97];
%                 dnsmpl_dat = filter(vB, vA, dnsmpl_dat')';
%                 dnsmpl_dat = conv2(dnsmpl_dat, BPF, 'same');
                str_split = strsplit(allnames{kk},'_good_elec_data');
                new_name  = [str_split{1}, '_good_data.mat'];
                cd(stim_dest_str)
                good_data = dnsmpl_dat(:,dnsmpl_t >= time_begin);
                if jj < 3
                    good_data = good_data(:,1:floor(end/2));
                end
                save(new_name,'good_data');
            end

        end
    end
end

end

