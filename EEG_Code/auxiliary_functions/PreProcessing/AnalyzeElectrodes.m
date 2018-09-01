close all
clear

dirPath = 'E:\EEG_Project\GoodData\edited_EEG_data\C03\Stim_03\good_data\';
Files   = dir([dirPath, '*trial*.mat']);
L       = length(Files);
amplitudeThr = 10;
% stdMaxVal = 2e-4;
stdMaxVal = inf;
stdMinVal    = 1e-7;
zeroThr   = 10;
figure;
for ii = 1 :10: L
    fileName = Files(ii).name;
    load([dirPath, fileName]);
    F = good_data;
    [Ns, sigLength] = size(F);
%     for nn = 1 : Ns
%        plot(F(nn,:)); title([fileName, ', #', num2str(nn)]); drawnow; pause(1);
%     end
    
    vN = 1 : Ns;

%     vAmpMax         = max(abs(F), [], 2);
%     vValidIdx       = vAmpMax < amplitudeThr;
%     F(~vValidIdx,:) = [];
%     vN(~vValidIdx)  = [];

%     N2 = sum(vValidIdx);
        
    vStd     = std(F, [], 2);
    vDiff    = diff(F,[],2);
    filt_mat = ones(1,101);
    stdDiff  = std(stdfilt(vDiff,filt_mat),[],2);
    Fmean    = F - mean(F,2);
    cF       = num2cell(Fmean,2);
    vZero    = cellfun(@(x)zero_cross(x),  cF);
    vValidIdx       = (vStd < stdMaxVal) .* (vStd > stdMinVal);
%     vValidIdx       = vValidIdx .* (stdDiff/median(stdDiff) < amplitudeThr) .* (vZero > zeroThr) .* max((vZero > 20),(vStd < 2.5e-5));
    F(~vValidIdx,:) = [];
    vN(~vValidIdx)  = [];
    N2 = sum(vValidIdx);
    sigStd = std(F(:));
%     vStd(65) = [];
    F2   = F + 2 * sigStd * (1 : N2)';
    
%     figure;
    subplot(1,2,1); stem(std(F, [], 2)); ylim([0, 5e-4]);
    subplot(1,2,2);
    plot(F2');
    title([num2str(ii), '. # = ', num2str(N2)]); drawnow; pause(0.6); 
    
    if all( diff(F2(:,1)) > 0 ) == true
        ax            = gca;
        ax.YTick      = F2(:,1);
        ax.YTickLabel = vN;
    end
  
end

