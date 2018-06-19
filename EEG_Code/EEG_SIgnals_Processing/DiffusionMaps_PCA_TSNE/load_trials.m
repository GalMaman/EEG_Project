function [ data_cell, legend_cell, label_struct ] = load_trials( pick_stims, pick_subj,subjs, src_dir, stims, num_of_trials, elec_data)

data_cell   = cell(length(pick_stims), length(pick_subj));   % cell that will hold all cov mats of every stim and subject
legend_cell = data_cell;    % holds the names of the stims and subjs
stims_str   = cell(1,length(pick_stims));
legend_str  = zeros(length(pick_subj) * length(pick_stims), 1);     % the legend size - will plug in subject and stim later
label_sub   = zeros(length(pick_subj) * length(pick_stims), 1);     % the label for the SVM -per subject
label_st    = zeros(length(pick_subj) * length(pick_stims), 1);     % the label for the SVM -per stimulation
label_con   = zeros(length(pick_subj) * length(pick_stims), 1);      % the label for the SVM - sick = 1, healthy = 0
stims_ID    = {'right arm', 'left arm', 'light flash', 'frequent tone', 'rare tone', 'sham word 1', 'subject own name', 'sham word ', 'sham word '};


for ind_subj = 1:length(pick_subj)
    for ind_stim = 1:length(pick_stims)
        % Gives a label of sick/not sick (1=sick):
        label_con((ind_subj-1) * length(pick_stims) + ind_stim) = contains(subjs{pick_subj(ind_subj)}, "S");
        label_sub((ind_subj-1) * length(pick_stims) + ind_stim) = pick_subj(ind_subj);
        label_st((ind_subj-1) * length(pick_stims) + ind_stim) = pick_stims(ind_stim);
        
        % finding cov directory of temporary subject-stim:
        if elec_data == 0
            temp_dir    = [src_dir, '\', subjs{pick_subj(ind_subj)}, '\',...
                                              stims{pick_stims(ind_stim)}, '\clean'];
            
            cd(temp_dir);   % moving to cov directory for current subject and stimulation
            temp_files  = dir(temp_dir);
            temp_names  = {temp_files.name}.';
            temp_trials = temp_names(contains(temp_names, 'trial')); % all trials
            if (num_of_trials == inf) || (num_of_trials > length(temp_trials))
                load_struct = cellfun(@(X) load(X, 'clean_data'), temp_trials);
            else
                load_struct = cellfun(@(X) load(X, 'clean_data'), temp_trials(1:num_of_trials));
%                 trials_idx  = randperm(length(temp_trials));
%                 load_struct = cellfun(@(X) load(X, 'clean_data'), temp_trials(trials_idx(1:num_of_trials)));
            end
        else
            temp_dir    = [src_dir, '\', subjs{pick_subj(ind_subj)}, '\',...
                                              stims{pick_stims(ind_stim)}, '\good_data']; 
            cd(temp_dir);   % moving to cov directory for current subject and stimulation
            temp_files  = dir(temp_dir);
            temp_names  = {temp_files.name}.';
            temp_trials = temp_names(contains(temp_names, 'trial')); % all trials
            if (num_of_trials == inf) || (num_of_trials > length(temp_trials))
                load_struct = cellfun(@(X) load(X, 'good_data'), temp_trials);
            else
                load_struct = cellfun(@(X) load(X, 'good_data'), temp_trials(51:50+num_of_trials));
%                 trials_idx  = randperm(length(temp_trials));
%                 load_struct = cellfun(@(X) load(X, 'good_data'), temp_trials(sort(trials_idx(1:num_of_trials))));
            end
        end
        data_cell{ind_stim,ind_subj}   = struct2cell(load_struct).';    % loading into cell
        legend_cell{ind_stim,ind_subj} = [subjs{pick_subj(ind_subj)}, ' - ', stims{pick_stims(ind_stim)},sprintf( ' %s', stims_ID{pick_stims(ind_stim)})];  
                                                                              % updating legend
%         stims_str{ind_stim} =  [stims{pick_stims(ind_stim)},sprintf( ' %s', stims_ID{pick_stims(ind_stim)})];
        stims_str{ind_stim} =  stims_ID{pick_stims(ind_stim)};                                                                     
    end
end

label_struct    = cell(5,1);
label_struct{1} = legend_str;
label_struct{2} = label_con;
label_struct{3} = label_sub;
label_struct{4} = label_st;
label_struct{5} = stims_str;