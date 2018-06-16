function [U,S] = AlgoPCA(X)

mMean     = mean(X, 2);
new_mat   = X - mMean;
% [U, ~, ~] = svd(new_mat, 'econ');
if nargout == 1
    [U, ~, ~] = svd(new_mat);
else
    [U, S, ~] = svd(new_mat);
%     [U, S, ~] = eig(new_mat * new_mat');
%     [S,I]     = sort(diag(S),'descend');
%     S         = diag(S);
%     U         = U(:, I);
end