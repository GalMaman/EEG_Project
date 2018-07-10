function [U,Y] = AlgoPCA(X)

mMean     = mean(X, 2);
new_mat   = X - mMean;
% [U, ~, ~] = svd(new_mat, 'econ');
if nargout == 1
    [U, ~, ~] = svd(new_mat);
else
    [U, S, V] = svd(new_mat);
    S = S / S(1,1);
    Y = U * S * V';
%     [U, S, ~] = eig(new_mat * new_mat');
%     [S,I]     = sort(diag(S),'descend');
%     S         = diag(S);
%     U         = U(:, I);
end