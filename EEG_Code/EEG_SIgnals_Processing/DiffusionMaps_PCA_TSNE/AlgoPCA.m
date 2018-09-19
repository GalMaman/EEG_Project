function [U,S,Y] = AlgoPCA(X)

mMean     = mean(X, 2);
new_mat   = X - mMean;

if nargout == 1
    [U, ~, ~] = svd(new_mat);
else
	[U, S, V] = svd(new_mat);
%     S = S ./ max(diag(S));
    Y = U * S * V';
    
end