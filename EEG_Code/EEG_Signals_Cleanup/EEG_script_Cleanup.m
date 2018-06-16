%% Gilad Hecht and Ronen Rahamim, June 18th 2017
% EEG_script_Cleanup
% Runs cleanup for a subject, over all stimulations, given that they are
% ordered in the standard manner.
% Downsampples to 1KHz and cuts from t=0 to end.
% For the somatosensory takes from t=0.07sec.
% Clearing the stims from bad electrodes and bad trials, and afterwards it
% saves the relevant data from the good electrodes and calculate the
% covariance matrix for each stimulation in each subject.
% Organizes everything in edited_data directory.

clear;
clc;
c_begin = fix(clock);

%% get directories:
% prompt = {'Enter the original data directory',...
%           'Enter edited data destination:'};
% title  = 'Directories';
% directories        = inputdlg(prompt,title);
% 
% %% Splitting directories
% source_direct = directories{1};
% dest_direct   = directories{2};
source_direct = 'E:\EEG_Project\EEG_data_organized';
dest_direct   = 'E:\EEG_Project\DataNoFilter';
cellfun(@(x) addpath(x), {source_direct;dest_direct});
cd(dest_direct);

%% Initializing directories and stims:
% Stims are:
stims_vec = [1 2 3 11 12 13 14 15 16];
% stims_vec = [1 2 3 11];
% Making directory tree
subj_names = find_subject_names( source_direct );
% subj_names = {'C01';'C02';'C03';'C04';'C05';'C06';'C07';'C08';'C10';'C11';'C12'};
% subj_names = {'C01';'C02';'C03';'C04';'C05'};
make_dir_tree( dest_direct, subj_names, stims_vec );
% edited_EEG_data path:
edited_EEG_data = [dest_direct, '\edited_EEG_data'];

%% Cleaning the data and downsampling it
disp('    --Cleaning and downsampling data...');
tic
% Clean_Stims( source_direct, edited_EEG_data, subj_names, stims_vec );
New_Clean_Stims( source_direct, edited_EEG_data, subj_names, stims_vec );
toc

%% Clearing out the bad electrodes
disp('    --Clearing out the bad electrodes...');
tic
Clear_Electrodes( edited_EEG_data, subj_names, stims_vec );
toc

%% cov matrices:
% disp('    --Calculating cov matrices...');
% tic
% calculate_covs( edited_EEG_data, stims_vec)
% toc

disp('    --Done!!');
c_finish = fix(clock);

