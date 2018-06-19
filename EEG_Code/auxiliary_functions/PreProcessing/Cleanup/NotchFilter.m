close all
clear

N = 10000;
vX = cumsum(randn(N,1));
vB = [1, -1];
vA = [1, -0.97];

vY = filter(vB, vA, vX);

figure; hold on;

plot(vX, 'b','LineWidth',2);
plot(vY, ':r','LineWidth',2);