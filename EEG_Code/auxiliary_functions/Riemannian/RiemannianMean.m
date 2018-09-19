function M = RiemannianMean(tC)

Np = size(tC, 3);
M  = mean(tC, 3);
% for ii = 1 : 20
% for ii = 1 : 200
%     A = M ^ (1/2);      %-- A = C^(1/2)
%     B = A ^ (-1);       %-- B = C^(-1/2)
%         
%     S = zeros(size(M));
%     for jj = 1 : Np
%         C = tC(:,:,jj);
%         S = S + A * logm(B * C * B) * A;
%     end
%     S   = S / Np;
%     M   = A * expm(B * S * B) * A; 
%     eps = norm(S, 'fro');
%     if (eps < 1e-6)
%         break;
%     end
% end

G = sum(tC,3);
tCinv = zeros(size(tC));
for ii = 1:Np
    tCinv(:,:,ii) = inv(tC(:,:,ii));
end

L = sum(tCinv,3);
A = L^(1/2);
B = A^(-1);
M = B * (A * G * A)^(1/2) * B;
end