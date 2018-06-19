function [zeros_num] = zero_cross(X)
 pos_sign  = sign(X) > 0;
 changes   = xor(pos_sign(1:end-1),pos_sign(2:end));
 zeros_num = sum(changes);