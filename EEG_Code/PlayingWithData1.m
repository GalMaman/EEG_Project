close all
clear

%%
dirPath = 'C:\Users\Oryair\Desktop\EEG DATA\';
Folders = {'C06\stim01\', 'C08\stim01\good data\', 'C11\stim01\'};
Folders = {'C06\stim14\', 'C08\stim14\good data\', 'C11\stim14\'};

Ns      = length(Folders);
S{Ns}   = [];


for ff = 1 : Ns
    Files = dir([dirPath, Folders{ff}, '*.mat']);
    Nf    = length(Files);
    
    load([dirPath, Folders{ff}, Files(2).name]);
    N     = size(good_data, 2);
    S{ff} = nan(46, N, Nf);
    
    for ii = 1 : length(Files)
        load([dirPath, Folders{ff}, Files(ii).name]);
        size(good_data)
        S{ff}(:,:,ii) = good_data(:,1:N);
    end
end


figure;
subplot(3,1,1); plot(mean(S{1}, 3)'); title('Subject C06');
subplot(3,1,2); plot(mean(S{2}, 3)'); title('Subject C08');
subplot(3,1,3); plot(mean(S{3}, 3)'); title('Subject C11');

    