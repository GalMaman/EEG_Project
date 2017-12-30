function [ cov_mat, RiemannianMean_3Dmat ] = cov2vec(cov_3Dmat)

num_of_subj          = size(cov_3Dmat,2);
RiemannianMean_3Dmat =[];

for jj = 1 : num_of_subj
    RiemannianMean_3Dmat = cat(3, RiemannianMean_3Dmat, cov_3Dmat{:,jj});
end
cov_mat = CovsToVecs(RiemannianMean_3Dmat);

end

