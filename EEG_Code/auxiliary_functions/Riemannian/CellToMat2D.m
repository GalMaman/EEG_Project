function [cov_2D_struct] = CellToMat2D(cov_3Dmat)

cov_2D_struct = cell(1, size(cov_3Dmat,2));
for jj = 1 : size(cov_3Dmat,2)
    temp2D = [];
    for ii =  1 : size(cov_3Dmat{jj},3)
        temp      = cov_3Dmat{jj}(:,:,ii);
        temp2D    = [temp2D temp(:)];
    end
    cov_2D_struct{jj} = temp2D;
end
    