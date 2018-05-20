function [Y] = calculate_dist_mat(X)

N = size(X,3);
Y = zeros(N);
for ii = 1 : N
    for jj = 1 : N
        Y(ii,jj) = norm(X(:,:,ii)-X(:,:,jj),'fro');
    end
end
