close all
clear

N     = 100;
mSigx = [10, 1;
        1, 2];
mSigy = [1, 2;
         2, 12];
vMu   = [0;
        0];
    
mX    = mvnrnd(vMu', mSigx, N)';
mY    = mvnrnd(vMu', mSigy, N)';   
figure; hold on; grid on;ax(1) = gca;
plot(mX(1,:), mX(2,:), '.b', 'MarkerSize', 20);
plot(mY(1,:), mY(2,:), '.g', 'MarkerSize', 20);
title('Before rotation','Interpreter','latex');
axis([-8,8,-7,7]);
[mUx, ~] = svd(mX);
[mUy, ~] = svd(mY);
quiver(0, 0, mUx(1,1), mUx(2,1), 5, 'r','LineWidth',2.5);
quiver(0, 0, mUx(1,2), mUx(2,2), 5, 'r','LineWidth',2.5)

quiver(0, 0, mUy(1,1), mUy(2,1), 5, '--r','LineWidth',2.5);
quiver(0, 0, mUy(1,2), mUy(2,2), 5, '--r','LineWidth',2.5);
xL = xlim;
yL = ylim;
line(xL, [0 0],'color','k','linewidth',0.1); 
line([0 0], yL,'color','k','linewidth',0.1); 

% rotation
vMult = sign(sum(mUx .* mUy));
mUy   = mUy .* vMult;

figure; hold on; grid on;ax(2) = gca;
plot(mUx(:,1)' * mX, mUx(:,2)' * mX, '.b', 'MarkerSize', 20);
plot(mUy(:,1)' * mY, mUy(:,2)' * mY, '.g', 'MarkerSize', 20);
xL = xlim;
yL = ylim;
title('After rotation','Interpreter','latex');
line(xL, [0 0],'color','k','linewidth',0.1); 
line([0 0], yL,'color','k','linewidth',0.1); 
axis([-6,6,-3.5,3.5]);
set(ax,'FontSize',14);