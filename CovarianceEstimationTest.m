close all;
clear;

vMu  = [5;
        3];
   
mSig = [50, 15;
        15, 25];
    
N  = 1000000;
mX = mvnrnd(vMu, mSig, N)';

% figure; hold on; grid on; scatter(mX(1,:), mX(2,:)); axis equal;

mX2 = mX - mean(mX, 2);
% figure; hold on; grid on; scatter(mX2(1,:), mX2(2,:)); axis equal;

1 / N * (mX2 * mX2')



