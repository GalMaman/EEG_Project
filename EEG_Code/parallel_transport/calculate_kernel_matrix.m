function [ kernel_X ] = calculate_kernel_matrix( X )
%Returns the covariance along the rows of the matrix
dis_mat  = squareform( pdist(X) );
epsilon  = median(dis_mat(:));
kernel_X = exp(-dis_mat.^2 / epsilon^2);

end