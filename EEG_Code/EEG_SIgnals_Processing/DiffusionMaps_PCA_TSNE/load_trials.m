function [ data_cell, legend_cell, legend_str, label ] = load_trials( pick_stims, pick_subj,subjs, src_dir, stims)

data_cell   = cell(length(pick_stims), length(pick_subj));   % cell that will hold all cov mats of every stim and subject
legend_cell = data_cell;    % holds the names of the stims and subjs
legend_str  = zeros(length(pick_subj) * length(pick_stims), 1);     % the legend size - will plug in subject and stim later
label       = zeros(length(pick_subj) * length(pick_stims), 1);      % the label for the SVM - sick = 1, healthy = 0
for ind_subj = 1:length(pick_subj)
    for ind_stim = 1:length(pick_stims)
        % Gives a label of sick/not sick (1=sick):
        label((ind_subj-1) * length(pick_stims) + ind_stim) = contains(subjs{pick_subj(ind_subj)}, "S");
        
        % finding cov directory of temporary subject-stim:
        temp_dir    = [src_dir, '\', subjs{pick_subj(ind_subj)}, '\',...
                                          stims{pick_stims(ind_stim)}, '\good_data'];
        cd(temp_dir);   % moving to cov directory for current subject and stimulation
        temp_files  = dir(temp_dir);
        temp_names  = {temp_files.name}.';
        temp_trials = temp_names(contains(temp_names, 'trial')); % all trials
        load_struct = cellfun(@(X) load(X, 'good_data'), temp_trials);
        data_cell{ind_stim,ind_subj}   = struct2cell(load_struct).';    % loading into cell
        legend_cell{ind_stim,ind_subj} = [subjs{pick_subj(ind_subj)}, ' - ', stims{pick_stims(ind_stim)}];  
                                                                              % updating legend
    end
end