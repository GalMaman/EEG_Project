function [ tmp_good_elec ] = Classify_Electrodes( stim_src_str, threshold,...
                                          eta, window_len,electrodes_num,...
                                          percent_trial, percent_stim,...
                                          bad_trial)
% This function checks what are the good electrodes for each stim when
% based on checking each trial.

counter = 0;
bad_electrodes = zeros(electrodes_num, 1);
allfiles = dir([stim_src_str, '\clean']);
allnames = {allfiles.name}.';
M = length(allnames);

bad_trials = zeros(electrodes_num, M);
bad_electrodes = zeros(electrodes_num, M);
trials_names = cell(M,1);
        
good_str   = contains(allnames,'trial');
        
for kk=1:M
    if good_str(kk) == 1
        counter = counter + 1;
        cd([stim_src_str, '\clean'])
        tmp_trial  = load(allnames{kk});
        field      = fieldnames(tmp_trial);
        tmp_trial  = getfield(tmp_trial, field{1});
        
        % Threshold condition
        [electrodes_num, trial_len] = size(tmp_trial);
%         out_of_bound = (abs(tmp_trial) > threshold);
%         tmp_bad_electrodes = sum(out_of_bound, 2);

        % Window filtering condition
        ones_window = ones(1,window_len);
        local_std_filted = stdfilt(tmp_trial,ones_window);
        local_mean_filted = imfilter(tmp_trial, ones_window) / window_len;
        local_data_corr  = (tmp_trial - local_mean_filted) ./ local_std_filted;
        local_bad_elec = local_data_corr > eta;
%         tmp_bad_electrodes = tmp_bad_electrodes + sum(local_bad_elec, 2);
        tmp_bad_electrodes = sum(local_bad_elec, 2);

        % All signal condition
        std_all = std(tmp_trial,0,1);
        mean_all = mean(tmp_trial,1);
        data_corr_all  = (tmp_trial - repmat(mean_all,electrodes_num,1)) ./ repmat(std_all,electrodes_num,1);
        total_bad_elec = data_corr_all > eta;
        tmp_bad_electrodes = tmp_bad_electrodes + sum(total_bad_elec, 2);
        
        % Very bad electrodes in a trial
        bad_trials(:, counter) = (tmp_bad_electrodes >= floor(bad_trial * trial_len));
        
        % Saving aside the names of the trails
        trials_names{counter} = allnames{kk};
        
        % Searching for the bad electrodes
        bad_electrodes(:, counter) = bad_electrodes(:, counter) + (tmp_bad_electrodes >= floor(percent_trial * trial_len));
    end
end

% Finding the good electrodes
tmp_good_elec = find(sum(bad_electrodes,2) <= floor(percent_stim * counter));
bad_electrodes(tmp_good_elec,:) = 0;
cd([stim_src_str, '\bad_electrodes'])
save('bad_elec.mat', 'bad_electrodes')

cd([stim_src_str, '\clean'])
bad_trials = bad_trials(tmp_good_elec, (1:counter));
trials_names = trials_names((1:counter),1);
is_bad_trial = sum(bad_trials,1) > 0;   % Checking the trials which were 
                                        % bad but didnt delete its bad
                                        % electrodes
bad_trials_num = sum(is_bad_trial);
ind_bad = find(is_bad_trial);

if (bad_trials_num > 0)
    for ii = 1:bad_trials_num
        delete(trials_names{ind_bad(ii)});
    end
end


end
