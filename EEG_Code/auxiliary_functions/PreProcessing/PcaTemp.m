close all
clear

N    = 100;
mSig = [3, 2;
        2, 2];
vMu  = [0;
        0];
    
mX      = mvnrnd(vMu', mSig, N)';
mX(:,1) = [-5;
           5];
       
figure; hold on; grid on;
plot(mX(1,:), mX(2,:), '.b', 'MarkerSize', 20);
PlotMainGrid

[mU, mL] = svd(mX);
quiver(0, 0, mU(1,1), mU(2,1), 10, 'g');
quiver(0, 0, mU(1,2), mU(2,2), 10, 'r');