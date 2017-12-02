function M = log_mat(X, S)

A = X ^ (1/2);      
B = A ^ (-1); 
M   = A * logm(B * S * B) * A;
end