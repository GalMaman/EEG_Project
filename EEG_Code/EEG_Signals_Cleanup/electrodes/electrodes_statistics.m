clear;
clc;
%% entering the 'edited_EEG_data' directory
% example in Gal's:     E:\EEG_Project\EEG_data_with_elec\edited_EEG_data
src_dir = 'E:\EEG_Project\FinalCleanData\edited_EEG_data'; % with IIR
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
        elec_vec = sum(data_cell{ind_stim,ind_subj}{1},2);
        elec_mat  = [elec_mat, elec_vec];
    end 
    all_data = cat(2, all_data, elec_mat);
    vYc = ind_subj * ones(68*length(pick_stims), 1);
    vY  = [vY;
          vYc];
end

hist_sub = [];
for ind_subj = 1:length(pick_subj) 
    hist_sub(:,ind_subj) = sum(all_data(:,1+9*(ind_subj-1):9*ind_subj),2);
end
hist_sub(hist_sub ~= 0) = 1;

%%
hist_sub(hist_sub == 0) = NaN;
hist_mat = sum(all_data,2);
hist_mat(hist_mat == 0) = NaN;
all_data(all_data == 0) = NaN;


[Y, X] = ndgrid(1:size(all_data,1), 1:size(all_data,2));

%% plot scatter
figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
scatter3(X(:), Y(:),all_data(:),100, vY, 'Fill')
zlabel({'Number of bad electrodes'});
ylabel('Electrodes');
xlabel('16 Subjects, 9 stimulations');
title({'Bad Electrodes Statistics'});
view(axes1,[-74.8333333333333 32.1333333333333]);
grid(axes1,'on');
set(axes1,'XTick',...
    [0 9 18 27 36 45 54 63 72 81 90 99 108 117 126 135 144],'YTick',...
    [1:2:68]);
%% plot hist
figure1 = figure;
axes1 = axes('Parent',figure1);
bar(hist_mat);
ylabel({'Number of bad trials'});
xlabel({'Electrodes'});
title({'Bad Electrodes Histogram'});
set(axes1,'XTick',...
    [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69],...
    'YTick',[30 2000 4000 6000 8000 10000 12000]);

%% plot hist per subject
figure1 = figure;
for ind_subj = 1:length(pick_subj)
    subplot(4,4,ind_subj); 
    bar(hist_sub(:,ind_subj));
    ylabel({'trials'});
    xlabel({'electrodes'});
    title(sprintf('subject %s', cell2mat(subj_names(ind_subj))));
    subplot1 = subplot(4,4,ind_subj,'Parent',figure1);
    set(subplot1,'XTick',[1 11 21 31 41 51 61 68],'YTick',...
        [0 1000 2000 3000 4000]);
end

elec_idx = find(hist_mat < 500);

%% plot hist - only potential good electrodes  
figure1 = figure;
axes1 = axes('Parent',figure1);
bar(hist_mat(elec_idx))
ylabel({'trials'});
xlabel({'electrodes'});
title({'Bad Electrodes Histogram - bad trials < 500 only'});
set(axes1,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12 13],'XTickLabel',...
    {elec_idx(1:13)});

%%  plot hist per subject
figure1 = figure;
for ind_subj = 1:length(pick_subj)
    subplot(4,4,ind_subj); 
    bar(hist_sub(elec_idx,ind_subj));
    ylabel({'trials'});
    xlabel({'electrodes'});
    title(sprintf('subject %s', cell2mat(subj_names(ind_subj))));
    subplot1 = subplot(4,4,ind_subj,'Parent',figure1);
    set(subplot1,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12 13],'XTickLabel',...
         {elec_idx(1:13)});
end