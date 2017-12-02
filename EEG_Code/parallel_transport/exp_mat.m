function M = exp_mat(X, S)

A = X ^ (1/2);      
B = A ^ (-1); 
M   = A * expm(B * S * B) * A;
end
