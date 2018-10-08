function mX = CovsToVecs(Covs, white, Riemannian_Mean)
% Covs is a 3D tensor: (row,cols,N)
    if nargin == 2
        mRiemannianMean = RiemannianMean(Covs);
    else
        mRiemannianMean = Riemannian_Mean;
    end
    mCSR            = mRiemannianMean^(-1/2);
    mSQRT           = mRiemannianMean^(1/2); 
    
    K  = size(Covs, 3);
    D  = size(Covs, 1);
    D2 = D * (D + 1) / 2;
    mX = zeros(D2, K);
    
    mW = sqrt(2) * ones(D) - (sqrt(2) - 1) * eye(D);
    for kk = 1 : K
        if white == 0
            Skk      = mSQRT * logm(mCSR * Covs(:,:,kk) * mCSR) * mSQRT .* mW;
%             Skk      = logm(Covs(:,:,kk)) .* mW;
        else
            Skk      = logm(mCSR * Covs(:,:,kk) * mCSR) .* mW;
        end
        mX(:,kk) = Skk(triu(true(size(Skk))));
%         mX(:,kk) = mX(:,kk) / norm(mX(:,kk));
    end
    
    
    mToep       = toeplitz(1:D);
    vTeop       = mToep(triu(true(size(mToep))));
    [~, vOrder] = sort(vTeop);
    mX          = mX(vOrder,:);
   
end