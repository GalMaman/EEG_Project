function [new_data_cell] = creating_fourier_cell(data_cell, pick_stims, pick_subj, n_fourier)

new_data_cell = cell(length(pick_stims), length(pick_subj));
temp_data_cell = cell(length(pick_stims), length(pick_subj));

for ii = 1 : length(pick_stims)
    for jj = 1 : length(pick_subj)
        for kk = 1 : length(data_cell{ii,jj})
            N = size(data_cell{ii,jj}{kk,1},1);
            for nn = 1 : N
                if length(n_fourier) > 1
%                     data_cell{ii,jj}{kk,1} = (data_cell{ii,jj}{kk,1} - mean(data_cell{ii,jj}{kk,1},2)) ./ std(data_cell{ii,jj}{kk,1},[],2);
%                     data_cell{ii,jj}{kk,1} = data_cell{ii,jj}{kk,1}- mean(data_cell{ii,jj}{kk,1},1);
                    temp = abs(fftshift(fft( data_cell{ii,jj}{kk,1}(nn,:))));
%                     temp = temp(1:ceil(end/2));
                    new_data_cell{ii,jj}{kk,1}(nn,:) = temp;
                else
                    temp_data_cell{ii,jj}{kk,1}(nn,:) = abs(fft( data_cell{ii,jj}{kk,1}(nn,:),n_fourier));
                end
                
            end
%             dist_mat  = squareform(pdist(new_data_cell{ii,jj}{kk,1}));
%             epsilon   = 3 * median(dist_mat(:));
%             new_data_cell{ii,jj}{kk,1} = exp(-dist_mat.^2 / ( epsilon)^2);
            new_data_cell{ii,jj}{kk,1} = cov_of_rows(new_data_cell{ii,jj}{kk,1});
%                 new_data_cell{ii,jj}{kk,1} = corrcoef(new_data_cell{ii,jj}{kk,1}');
%             new_data_cell{ii,jj}{kk,1} = new_data_cell{ii,jj}{kk,1} / max(new_data_cell{ii,jj}{kk,1}(:));
        end
        
    end
    
end

