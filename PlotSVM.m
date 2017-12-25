close all
clear
clc


N                        = 2000;
mX1                      = randn(2, N);
mX1(:,sum(mX1.^2) < 1.5) = [];
mX1(:,sum(mX1.^2) > 2.5) = [];

mX2                    = randn(2, N);
mX2(:,sum(mX2.^2) > 1) = [];

mX3                      = 1.5 * randn(2, N);
mX3(:,sum(mX3.^2) < 2.6) = [];

figure; hold on;
scatter(mX1(1,:), mX1(2,:), 'b');
scatter(mX2(1,:), mX2(2,:), 'r');
scatter(mX3(1,:), mX3(2,:), 'k');

M  = 200;

vC = [1 * ones(M, 1);
      2 * ones(M, 1);
      3 * ones(M, 1);
      ];
  
mData = [vC';
         mX1(:,1:M), mX2(:,1:M), mX3(:,1:M)
         ];
  
%%
[trainedLinearSvmClassifier, validationAccuracy] = trainCubicSVM(mData);

%%
v        = linspace(-4, 4, 100);
[X1, X2] = meshgrid(v, v);

mTest = [X1(:), X2(:)]';

vP = trainedLinearSvmClassifier.predictFcn(mTest);
figure; hold on;
scatter(mTest(1,:), mTest(2,:), 100, vP, 'Fill');
scatter(mX1(1,:), mX1(2,:), 'g');
scatter(mX2(1,:), mX2(2,:), 'r');
scatter(mX3(1,:), mX3(2,:), 'k');