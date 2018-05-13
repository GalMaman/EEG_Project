function [Y] = calculate_elec_cov(X)

N = size(X,1);
Y = [];
for ii = 1 : N
    Y = cat(3, Y, X(ii,:)' * X(ii,:));
end

    