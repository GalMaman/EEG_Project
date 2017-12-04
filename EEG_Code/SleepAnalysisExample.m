% close all;
clear;

addpath('../../');
addpath('../../tSNE_matlab/');

%%
Fs = 100;

cEdfFiles = {'SC4001E0-PSG.edf', 'SC4011E0-PSG.edf'};
cHypFiles = {'HYP_P1_N1.txt',    'HYP_P2_N1.txt'};

% cEdfFiles = {'SC4001E0-PSG.edf', 'SC4002E0-PSG.edf'};
% cHypFiles = {'HYP_P1_N1.txt',    'HYP_P1_N2.txt'};

% cEdfFiles = {'SC4001E0-PSG.edf', 'SC4011E0-PSG.edf', 'SC4021E0-PSG.edf'};
% cHypFiles = {'HYP_P1_N1.txt',    'HYP_P2_N1.txt',    'HYP_P3_N1.txt'};

L = length(cEdfFiles);

%%
T    = 50;
M    = 2000;
vC   = [];
vS   = [];
Covs = nan(3,3,0);
for ll = 1 : L
    
    %%-- Load Data:
    [cHeader, mData] = edfread(['./Data/', cEdfFiles{ll}]);
    mLabels          = ParseSleep(['./Data/', cHypFiles{ll}])';
    if ll == 2
        mLabels   = mLabels(:, 1 : end-1);
    end
    
    startSkip = mLabels(2,1);
    endSkip   = mLabels(2,end);
    mData     = mData(1:3, Fs * startSkip + 1 : end - Fs * endSkip);
    mLabels   = mLabels(:, 2 : end-1);
    
    N     = size(mData, 2);
    D     = mod(N, T * Fs);
    mData = mData(:,1:end-D);
    
    mX = reshape(mData, 3, Fs * T, []);
    
    t1  = cumsum(mLabels(2,:));
    vC1 = mLabels(1,:);
    t2  = 0 : T : t1(end);
    vC2 = interp1(t1, vC1, t2, 'Nearest');
    vC2 = vC2(2:end);
    
    vIdx = vC2 ~= 2;
    M    = sum(vIdx);

%     vIdx = randperm(size(mX,3), M);
    mX   = mX(:,:,vIdx);
    vC2  = vC2(vIdx);
    
    vC = cat(2, vC, vC2);
   %-- End Load Data------------------------------
    
    %%
    Covsi = nan(3,3,0);
    for ii = 1 : size(mX, 3)
        Covsi(:,:,end+1) = cov(mX(:,:,ii)');
    end
    
    if ll == 1
        M1 = RiemannianMean(Covsi);
    else
        ll
        M2 = RiemannianMean(Covsi);
        for jj = 1 : size(Covsi, 3)
            Covsi(:,:,jj) = SchildLadder(M2, M1, Covsi(:,:,jj));
%             Covsi(:,:,jj) = ExpMap(M1, LogMap(M2, Covsi(:,:,jj)));
        end
    end
    
    Covs = cat(3, Covs, Covsi);
    vS   = cat(2, vS, ll * ones(1, M));
end

%%
mX = CovsToVecs(Covs);

%%
figure; mZ = TSNE(mX', vC, 2, [], 30);

%%
figure; scatter(mZ(:,1), mZ(:,2), 100, vC, 'Fill'); colorbar;
figure; scatter(mZ(:,1), mZ(:,2), 100, vS, 'Fill'); colorbar;

%%
mW  = squareform( pdist(mX') );
eps = 1 * median(mW(:));
mK  = exp(-mW.^2 / eps^2);
mA  = mK ./ sum(mK, 2);

[mPhi, mLam] = eig(mA);

%%
% figure; scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, vC, 'Fill');
% figure; scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, vS, 'Fill');

%%
P = 20;
figure; mZ = TSNE(mPhi(:,2:P) * mLam(2:P,2:P), vC, 2, [], 50);

%%
figure; scatter(mZ(:,1), mZ(:,2), 100, vC, 'Fill'); colorbar;
figure; scatter(mZ(:,1), mZ(:,2), 100, vS, 'Fill'); colorbar;

%%
% mD     = (mPhi * mLam)';
% mD     = mX;
% mD     = mD - mean(mD, 2);
% [U, S] = svd(mD);
% mU     = U(:,1:3);
% mP     = mU' * mD;
% 
% figure; scatter3(mP(1,:), mP(2,:), mP(3,:), 100, vC, 'Fill');
% figure; scatter3(mP(1,:), mP(2,:), mP(3,:), 100, vS, 'Fill');
