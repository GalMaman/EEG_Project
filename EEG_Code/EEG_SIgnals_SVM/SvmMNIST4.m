close all;
clear;

addpath('../../SourceCode/MNIST');

%%
mX = loadMNISTImages('train-images.idx3-ubyte');
vY = loadMNISTLabels('train-labels.idx1-ubyte');

%%
N       = 2000;
mXTrain = mX(:,1:N);
vYTrain = vY(1:N);

mXTtest = mX(:,N+1:2*N);
vYTtest = vY(N+1:2*N);

% Data = [vYTrain'; mXTrain];

%% Linear:
linaerSvmTemplate = templateSVM('Standardize', true);
mdlLinearSVM      = fitcecoc(mXTrain', vYTrain, 'Learners', linaerSvmTemplate);

%% Gauss:
% gaussSvmTemplate = templateSVM('Standardize', true, 'KernelFunction', 'gaussian', 'KernelScale', 50);
% mdlGaussSVM      = fitcecoc(mXTrain', vYTrain, 'Learners', gaussSvmTemplate);

%% Knn:
knnSvmTemplate = templateKNN('NumNeighbors', 3);
mdlKnn         = fitcecoc(mXTrain', vYTrain, 'Learners', knnSvmTemplate);


%%
vPLinear = mdlLinearSVM.predict(mXTtest');
vPKnn    = mdlKnn.predict(mXTtest');

%%
close all
% figure('Position', [300, 300, 700, 700]);
% plotconfusion(categorical(vYTtest), categorical(vPLinear)); 
% title('Linear SVM');
% set(gca, 'FontSize', 16);

figure;
plotconfusion(categorical(vYTtest), categorical(vPKnn)); 
title('Knn (K = 3)');
set(gca, 'FontSize', 16);

%%
% figure('Position', [300, 300, 545, 520]);
% [CM, grp] = confusionmat(vPLinear, vYTtest);
% heatmap(grp, grp, CM); colorbar('off');
% % title('Heat Map');
% set(gca, 'FontSize', 16);

figure('Position', [300, 300, 545, 520]);
[CM, grp] = confusionmat(vPKnn, vYTtest);
heatmap(grp, grp, CM); colorbar('off');
% title('Heat Map');
set(gca, 'FontSize', 16);

%%
vErr = find(vPLinear ~= vYTtest);
ax   = tight_subplot(2, 10, 0.01, 0.05, 0.05);
kk   = 1;
figure;
for ii = 1 : 20
    I = reshape(mXTtest(:,vErr(ii)), [28, 28]);
    
    axes(ax(kk)); kk = kk + 1; hold on; set(gca, 'FontSize', 16);
    imshow(I); title({['Label     - ', num2str(vYTtest(vErr(ii)))];
                      ['Predicted - ', num2str(vPLinear(vErr(ii)))]});
end