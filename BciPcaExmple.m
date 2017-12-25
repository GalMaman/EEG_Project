close all;
clear;

addpath('./RiemannianTools');

%% Load Data:
% vSubjects  = [1, 3, 7, 8, 9];

[Events, vClass] = GetEvents(3, 1);

%% PCA:
vIdx    = ismember(vClass, [1, 4]);
vClass1 = vClass(vIdx);
Events  = Events(vIdx);
mX      = cat(1, Events{:})';
mX      = mX - mean(mX, 2);
[U, S]  = svd(mX, 'econ');
mU      = U(:,1:2);

%%
Covs1 = PcaCovs(Events, mU);

%% Subject 2:
[Events, vClass] = GetEvents(8, 2);
vIdx    = ismember(vClass, [1, 4]);
vClass2 = vClass(vIdx);
Events  = Events(vIdx);
Covs2   = PcaCovs(Events, mU);

%%
figure; hold on; grid on; %axis equal;
PlotPositiveMatrix(max(max(cat(1, Covs1{:}))));
PlotCovs(Covs1, vClass1, 'd');
PlotCovs(Covs2, vClass2, 'x');

%%
Covs    = [Covs1, Covs2];
M       = RiemannianMean(cat(3, Covs{:}));
% M       = 5000 * eye(2);
Covs1PT = PT(Covs1, M);
Covs2PT = PT(Covs2, M);

figure; hold on; grid on; %axis equal;
PlotPositiveMatrix(max(max(cat(1, Covs1{:}))));
PlotCovs(Covs1PT, vClass1, 'd');
PlotCovs(Covs2PT, vClass2, 'x');

%%
vS     = [1 * ones(144, 1);
          2 * ones(144, 1)];
Covs   = [Covs1, Covs2];
vClass = [vClass1; vClass2];
mW     = CalcRiemannianDist(Covs);
[mPhi, mLam] = DiffusionMaps(mW);
% PlotDM(mPhi, vClass, vS);

P = 100;
figure; mZ = TSNE(mPhi(:,2:P) * mLam(2:P,2:P), {vClass, vS}, 2, [], 10);

%%
CovsPT       = [Covs1PT, Covs2PT];
mW           = CalcRiemannianDist(CovsPT);
[mPhi, mLam] = DiffusionMaps(mW);
% PlotDM(mPhi, vClass, vS);

P = 100;
figure; mZ = TSNE(mPhi(:,2:P) * mLam(2:P,2:P), {vClass, vS}, 2, [], 10);

%%
% Ne  = size(Covs, 3);
% mX  = CovsToVecs(Covs);
% mW  = squareform( pdist( mX') );
% eps = median(mW(:));
% mK  = exp(-mW.^2 / eps^2);
% 
% %%
% % figure; imagesc(mK); colorbar;
% mA = mK ./ sum(mK, 2);
% [mPhi, mLam] = eig(mA);
% 
% %%
% figure; scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, vClass, 'Fill');
% 
% %%
% P = 100;
% figure; mZ = TSNE(mPhi(:,2:P) * mLam(2:P,2:P), vClass, 2, [], 120);

%======End=Sciprt=======================================================================================%

%%
function PlotCovs(Covs, vC, marker)
    mCov      = cat(3, Covs{:});
    mCov      = reshape(mCov, 4, []);
    
    K  = max(mCov(:));
    vK = linspace(0, K, 100);
    scatter3(mCov(1,:), mCov(2,:), mCov(4,:),   50, vC, marker, 'LineWidth', 3);
    scatter3(vK,        0*vK,      vK, 10, 'r',           'Fill');
    plot3   (1,         0,         1,  '.b', 'MarkerSize', 20);
end

%%
function Covs = PcaCovs(Events, mU)
    for ii = 1 : length(Events)
        mX = Events{ii}';
        mP = mU' * mX;
        Covs{ii} = cov(mP');
    end
end

%%
function CovsPT = PT(Covs, M)
    mCovs = cat(3, Covs{:});
    M1    = RiemannianMean(mCovs);
    
    plot3   (M1(1), M1(2), M1(4), 'xb', 'MarkerSize', 20, 'LineWidth', 3);
    plot3   (M(1),  M(2),  M(4),  'xg', 'MarkerSize', 20, 'LineWidth', 3);
    CovsPT = Covs;
    for ii = 1 : length(Covs)
        %     ii
        mC = Covs{ii};
        %     CovsPT{ii,ss} = ExpMap(M, LogMap(Ms, mC));
        CovsPT{ii} = SchildLadder(M1, M, mC);
    end
end

%%
function mW = CalcRiemannianDist(Covs)
    L  = numel(Covs);
    mW = zeros(L, L);
    for ii = 1 : L
%         ii
        mC1 = Covs{ii};
        for jj = ii + 1 : L
            mC2       = Covs{jj};
            mW(ii,jj) = RiemannianDist(mC1, mC2);
        end
    end
    mW = mW + mW';
end

%%
function [mPhi, mLam] = DiffusionMaps(mW)
    eps = 2 * median(mW(:));
    mK  = exp(-mW.^2 / eps^2);
    mA  = mK ./ sum(mK, 2);
    
    [mPhi, mLam] = eig(mA);
    mPhi = mPhi * mLam;
end

%%
function PlotDM(mPhi, vClass, vS)
    figure; hold on; set(gca, 'FontSize', 18);
    scatter(mPhi(:,2), mPhi(:,3), 100, vClass, 'Fill'); colorbar;
    title('Diffusion Maps - Covariance, Color by Class');
    xlabel('$\psi_1$', 'Interpreter', 'Latex'); ylabel('$\psi_2$', 'Interpreter', 'Latex');
    figure; hold on; set(gca, 'FontSize', 18);
    scatter(mPhi(:,2), mPhi(:,3), 100, vS, 'Fill'); colorbar;
    title('Diffusion Maps - Covariance, Color by subject');
    xlabel('$\psi_1$', 'Interpreter', 'Latex'); ylabel('$\psi_2$', 'Interpreter', 'Latex');
end