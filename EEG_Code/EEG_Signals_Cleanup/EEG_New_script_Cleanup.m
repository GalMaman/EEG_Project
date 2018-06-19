clear;
close all;

%% get directories:
source_direct = 'E:\EEG_Project\EEG_data_organized';
dest_direct   = 'E:\EEG_Project\NewData2';
cellfun(@(x) addpath(x), {source_direct;dest_direct});
cd(dest_direct);

%% Initializing directories and stims:
% Stims are:
stims_vec = [1 2 3 11 12 13 14 15 16];
% Making directory tree
% subj_names = find_subject_names( source_direct );
subj_names = {'C01';'C02';'C03';'C04';'C05';'C06';'C07';'C08';'C10';'C11';'C12'};
make_dir_tree( dest_direct, subj_names, stims_vec );
% edited_EEG_data path:
edited_EEG_data = [dest_direct, '\edited_EEG_data'];

%% Clearing out the bad electrodes
disp('    --Clearing out the bad electrodes...');
tic
New_Clear_Electrodes(source_direct, edited_EEG_data, subj_names, stims_vec);
toc

%% Cleaning the data and downsampling it
disp('    --Cleaning and downsampling data...');
tic
New_Clean_Stims(edited_EEG_data, subj_names, stims_vec );
toc
