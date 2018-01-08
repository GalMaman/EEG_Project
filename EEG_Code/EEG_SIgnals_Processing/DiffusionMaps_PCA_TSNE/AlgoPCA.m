function [U] = AlgoPCA(X)

mMean     = mean(X, 2);
new_mat   = X - mMean;
[U, ~, ~] = svd(new_mat, 'econ');
