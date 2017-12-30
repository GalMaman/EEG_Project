function [U] = AlgoPCA(X)

mMean   = mean(X, 2);
new_mat = X - mMean;
[U,S,V] = svd(new_mat);