function [ tmp_good_elec ] = New_Classify_Electrodes(stim_src_str, stim_dest_str)

electrodes_num = 68;
counter        = 0;
allfiles       = dir([stim_src_str]);
allnames       = {allfiles.name}.';
M              = length(allnames);
% bad_trials     = zeros(electrodes_num, M);
bad_electrodes = zeros(electrodes_num, M);
trials_names   = cell(M,1);
good_str       = contains(allnames,'trial');
percent_stim   = 0.1;

% Tresholds
amplitudeThr = 10;
stdMaxVal    = 3.5e-4;
stdMinVal    = 2.5e-6;
% zeroThr      = 10;
filt_mat     = ones(1,101);
data         = struct;
for kk=1:M
    if good_str(kk) == 1
        counter = counter + 1;
        trials_names{counter} = allnames{kk};
        cd([stim_src_str])
        tmp_trial  = load(allnames{kk});
        data.F     = tmp_trial.F;
        data.Time  = tmp_trial.Time;
        F          = tmp_trial.F;
        cd([stim_dest_str, '\clean'])
        save(allnames{kk}, 'data');
        vStd                       = std(F, [], 2);
%         vDiff                      = diff(F,[],2);
%         stdDiff                    = std(stdfilt(vDiff,filt_mat),[],2);
%         Fmean                      = F - mean(F,2);
%         cF                         = num2cell(Fmean,2);
%         vZero                      = cellfun(@(x)zero_cross(x),  cF);
%         vValidIdx                  = (vStd < stdMaxVal) .* (vStd > stdMinVal) .* ...
%                                      (stdDiff/median(stdDiff) < amplitudeThr) .* (vZero > zeroThr) .* ...
%                                       max((vZero > 30),(vStd < 2.5e-5));
         vValidIdx                  = (vStd < stdMaxVal) .* (vStd > stdMinVal);
        bad_electrodes(:, counter) = ~vValidIdx;
        trials_names{counter} = allnames{kk};
%         bad_trials(:, counter)     = ~vValidIdx;
    end
end

very_bad_trial = sum(bad_electrodes,1) > 25;
if sum(very_bad_trial) > 0
    cd([stim_dest_str, '\clean']);
    idx_bad = find(very_bad_trial == 1);
    for ii = 1:length(idx_bad)
        delete(trials_names{idx_bad(ii)});
        bad_electrodes(:,idx_bad(ii)) = 0;
    end
end
% Finding the good electrodes
cd([stim_dest_str, '\bad_electrodes'])
save('bad_trials.mat', 'bad_electrodes')
trials_names = trials_names((1:counter),1);
save('trials_names.mat', 'trials_names')
tmp_good_elec = find(sum(bad_electrodes,2) <= floor(percent_stim * counter));
bad_electrodes(tmp_good_elec,:) = 0;
save('bad_elec.mat', 'bad_electrodes')

% cd([stim_dest_str, '\clean'])
% bad_trials = bad_trials(tmp_good_elec, (1:counter));
% trials_names = trials_names((1:counter),1);
% is_bad_trial = sum(bad_trials,1) > 0;   % Checking the trials which were 
%                                         % bad but didnt delete its bad
%                                         % electrodes
% bad_trials_num = sum(is_bad_trial);
% ind_bad = find(is_bad_trial);
% 
% if (bad_trials_num > 0)
%     for ii = 1:bad_trials_num
%         delete(trials_names{ind_bad(ii)});
%     end
% end


end
