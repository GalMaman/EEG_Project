close all
clear

dirPath = 'E:\EEG_Project\EEG_data_organized\C05\Stim_12\';
Files   = dir([dirPath, '*trial*.mat']);
L       = length(Files);

amplitudeThr = 8e-5;

figure;
for ii = 1 : L
    fileName = Files(ii).name
    load([dirPath, fileName])
    
    [Ns, sigLength] = size(F);
%     for nn = 1 : Ns
%        plot(F(nn,:)); title([fileName, ', #', num2str(nn)]); drawnow; pause(1);
%     end
    
    vN = 1 : Ns;

    vAmpMax         = max(abs(F), [], 2);
    vValidIdx       = vAmpMax < amplitudeThr;
%     F(~vValidIdx,:) = [];
%     vN(~vValidIdx)  = [];

    N2 = sum(vValidIdx);
    
    sigStd = std(F(:));
    
    vStd     = std(F, [], 2);
    vStd(65) = [];
%     F2   = F + 2 * sigStd * (1 : N2)';
    
%     figure;
    subplot(1,1,1); stem(vStd); ylim([0, 3e-4]);
%     subplot(1,2,2);
%     plot(F2');
    title([num2str(ii), '. # = ', num2str(N2)]); drawnow; pause(1); 
    
%     if all( diff(F2(:,1)) > 0 ) == true
%         ax            = gca;
%         ax.YTick      = F2(:,1);
%         ax.YTickLabel = vN;
%     end
  
end

