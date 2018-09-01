% close all
clear

dirPath1 = 'E:\EEG_Project\GoodData\edited_EEG_data\C01\Stim_03\good_data\';
Files1   = dir([dirPath1, '*trial*.mat']);
L       = length(Files1);
dirPath2 = 'E:\EEG_Project\GoodData\edited_EEG_data\C01\Stim_14\good_data\';
Files2   = dir([dirPath2, '*trial*.mat']);
figure;
for ii = 50 :1: 100
    fileName1 = Files1(ii).name;
    load([dirPath1, fileName1]);
    F = good_data;
    [Ns, sigLength] = size(F);
    sigStd = std(F(:));
    F1  = F + 2 * sigStd * (1 : Ns)';
    temp = zeros(size(F));
    for jj = 1 : Ns
        
        temp(jj,:) = abs(fftshift(fft(F(jj,:))));
%         temp(jj,:) = temp(jj,:) ./ std(temp(jj,:));
    end
%     temp = temp / max(temp(:));
    F2 =  cov_of_rows(temp);
    F2 =  F2 / max(F2(:));
    %%%%
    fileName2 = Files2(ii).name;
    load([dirPath2, fileName2]);
    M = good_data;
    [Ns, sigLength] = size(M);
    sigStd = std(M(:));
    M1  = M + 2 * sigStd * (1 : Ns)';
    temp = zeros(size(M));
    for jj = 1 : Ns
        temp(jj,:) = abs(fftshift(fft(M(jj,:))));
%         temp(jj,:) = temp(jj,:) ./ std(temp(jj,:));
    end
%     temp = temp / max(temp(:));
    M2 =  cov_of_rows(temp);
    M2 =  M2 / max(M2(:));
    subplot(2,2,1);imagesc(F2); colorbar;
    subplot(2,2,2);
    plot(F1');
    subplot(2,2,3);imagesc(M2); colorbar;
    subplot(2,2,4);
    plot(M1');
    title([num2str(ii), '. # = ']); drawnow; pause(0.6); 
    
    if all( diff(F2(:,1)) > 0 ) == true
        ax            = gca;
        ax.YTick      = F2(:,1);
        ax.YTickLabel = vN;
    end
  
end