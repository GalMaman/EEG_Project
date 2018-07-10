function make_dir_tree( root_dir, subjects, stims_vec)
% makes directory tree, for all the subjects within the root directory
cd(root_dir);
mkdir('edited_EEG_data');
cd('edited_EEG_data');
N = length(subjects);
name_str  = [];
for ii = 1:N
    name_str = subjects{ii};
    mkdir(name_str);
    for jj = stims_vec
        if jj>3
            stim_str = [name_str, '\Stim_', num2str(jj)];
            mkdir(name_str , ['Stim_', num2str(jj)]);
        else
            stim_str = [name_str, '\Stim_0', num2str(jj)];
            mkdir(name_str , ['Stim_0', num2str(jj)]);
        end
        
%         mkdir(stim_str , 'good_elec_data');      % data with only good electrodes
        mkdir(stim_str , 'good_data');  % clean data with good electrodes
        mkdir(stim_str , 'bad_electrodes');  % save electrodes table for each subject
        mkdir(stim_str , 'clean');  % trials that were not rejected        
    end
end
        

end

