clear;
clc;
%% entering the 'edited_EEG_data' directory
% example in Gal's:     E:\EEG_Project\EEG_data_with_elec\edited_EEG_data

prompt     ={'Enter data directory'};
dir_title  = 'data';
src_cell   = inputdlg(prompt,dir_title);
src_dir    = src_cell{1};
cd(src_dir);

%% choosing subjects
subjs      = find_subject_names(src_dir);
pick_subj  = listdlg('PromptString', 'Select subjects;', 'SelectionMode',...
    'multiple', 'ListString', subjs);
subj_names = subjs(pick_subj);

%% choosing stims
stims      = find_stims( src_dir, subj_names );
pick_stims = listdlg('PromptString', 'Select stimulations;', 'SelectionMode',...
    'multiple', 'ListString', stims);
stim_names = stims(pick_stims);

%% Adding trials from chosen subjects and stims into cells
tic
data_cell   = cell(length(pick_stims), length(pick_subj));   % cell that will hold all cov mats of every stim and subject
legend_cell = data_cell;    % holds the names of the stims and subjs
legend_str  = zeros(length(pick_subj) * length(pick_stims), 1);     % the legend size - will plug in subject and stim later
label       = zeros(length(pick_subj) * length(pick_stims), 1);      % the label for the SVM - sick = 1, healthy = 0

for ind_subj = 1:length(pick_subj)
    for ind_stim = 1:length(pick_stims)

        temp_dir    = [src_dir, '\', subjs{pick_subj(ind_subj)}, '\',...
                                          stims{pick_stims(ind_stim)}, '\bad_electrodes'];
        cd(temp_dir);   % moving to cov directory for current subject and stimulation
        temp_files  = dir(temp_dir);
        temp_names  = {temp_files.name}.';
        temp_trials = temp_names(contains(temp_names, 'bad_elec')); % all trials
        load_struct = load('bad_elec');
        
        data_cell{ind_stim,ind_subj}   = struct2cell(load_struct).';    % loading into cell
        legend_cell{ind_stim,ind_subj} = [subjs{pick_subj(ind_subj)}, ' - ', stims{pick_stims(ind_stim)}];  
                                                                              % updating legend
    end
end
all_data = [];
vY = [];
for ind_subj = 1:length(pick_subj)
    elec_mat = [];
    for ind_stim = 1:length(pick_stims)
        elec_vec = sum(data_cell{ind_stim,1}{:,:},2);
        elec_vec(elec_vec == 0) = NaN;
        elec_mat  = [elec_mat, elec_vec];
    end 
    all_data = cat(2, all_data, elec_mat);
    vYc = ind_subj * ones(68*length(pick_stims), 1);
    vY  = [vY;
          vYc];
end
% Data = [vY';
%         all_data];

% stim_mat = [];
% stim_label = [];
% for ind_stim = 1:length(pick_stims)
%     temp_mat = data_cell{ind_stim,1}{:,:};
%     stim_mat = cat(2, stim_mat, temp_mat);
%     temp_label = ind_stim*ones(size(temp_mat,2),1);
%     stim_label = [stim_label;
%                   temp_label];
% end
% 
%     
% data = [stim_label';
%         stim_mat];
% elec_vec = 1:68;    
% figure()
% scatter3(elec_vec, stim_label, stim_mat,100, 'fill')
[Y, X] = ndgrid(1:size(all_data,1), 1:size(all_data,2));

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
scatter3(X(:), Y(:),all_data(:),100, vY, 'Fill')
% legend(subj_names, 'Interpreter', 'none', 'location','southeastoutside');
zlabel({'Number of bad electrodes'});
ylabel('Electrodes');
xlabel('16 Subjects, 9 stimulations');
title({'Bad Electrodes Statistics'});
view(axes1,[-74.8333333333333 32.1333333333333]);
grid(axes1,'on');
set(axes1,'XTick',...
    [0 9 18 27 36 45 54 63 72 81 90 99 108 117 126 135 144],'YTick',...
    [30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68]);

