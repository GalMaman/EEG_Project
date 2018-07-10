function [ tmp_good_elec ] = Classify_Electrodes_V2(stim_src_str)

electrodes_num = 68;
counter        = 0;
allfiles       = dir([stim_src_str, '\clean']);
allnames       = {allfiles.name}.';
M              = length(allnames);
% bad_trials     = zeros(electrodes_num, M);
bad_electrodes = zeros(electrodes_num, M);
trials_names   = cell(M,1);
good_str       = contains(allnames,'trial');
percent_stim   = 0.1;

% Tresholds
stdMaxVal    = 2e-4; %3.5e-4;
stdMinVal    =1e-7; %2.5e-6;
for kk=1:M
    if good_str(kk) == 1
        counter               = counter + 1;
        trials_names{counter} = allnames{kk};
        cd([stim_src_str, '\clean'])
        tmp_trial                  = load(allnames{kk});
        field                      = fieldnames(tmp_trial);
        F                          = getfield(tmp_trial, field{1});
        vStd                       = std(F, [], 2);
        vValidIdx                  = (vStd < stdMaxVal) .* (vStd > stdMinVal);
        bad_electrodes(:, counter) = ~vValidIdx;
        trials_names{counter}      = allnames{kk};
    end
end
bad_electrodes = bad_electrodes(:, 1:counter);
bad_trials     = bad_electrodes;
trial_idx      = 1:counter;
very_bad_trial = sum(bad_electrodes,1) > 25;
if sum(very_bad_trial) > 0
    cd([stim_src_str, '\clean']);
    idx_bad = find(very_bad_trial == 1);
    for ii = 1:length(idx_bad)
        delete(trials_names{idx_bad(ii)});
        bad_electrodes(:,idx_bad(ii)) = 0;
        trial_idx = intersect(trial_idx, setdiff(1:counter,idx_bad(ii)));
    end
end
% Finding the good electrodes
tmp_good_elec                   = find(sum(bad_electrodes,2) <= floor(percent_stim * counter));
bad_electrodes(tmp_good_elec,:) = 0;

% cd([stim_src_str, '\clean'])
bad_trials     = bad_trials(tmp_good_elec, :);
trials_names   = trials_names((1:counter),1);
is_bad_trial   = sum(bad_trials,1) > 0;                                           
bad_trials_num = sum(is_bad_trial);
idx_bad        = find(is_bad_trial);

if (bad_trials_num > 0)
    for ii = 1:bad_trials_num
        delete(trials_names{idx_bad(ii)});
        trial_idx = intersect(trial_idx, setdiff(1:counter,idx_bad(ii)));
    end
end
bad_electrodes = bad_electrodes(:,trial_idx);
cd([stim_src_str, '\bad_electrodes'])
save('bad_elec.mat', 'bad_electrodes')
end
