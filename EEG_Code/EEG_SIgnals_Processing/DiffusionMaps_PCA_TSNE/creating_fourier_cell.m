function [new_data_cell] = creating_fourier_cell(data_cell, pick_stims, pick_subj, n_fourier)

new_data_cell = cell(length(pick_stims), length(pick_subj));
temp_data_cell = cell(length(pick_stims), length(pick_subj));

for ii = 1 : length(pick_stims)
    for jj = 1 : length(pick_subj)
        for kk = 1 : length(data_cell{ii,jj})
            N = size(data_cell{ii,jj}{kk,1},1);
            for nn = 1 : N
                if length(n_fourier) > 1
                    temp = abs(fft( data_cell{ii,jj}{kk,1}(nn,:)));
%                     temp_data_cell{ii,jj}{kk,1}(nn,:) = temp(4:80);
                    new_data_cell{ii,jj}{kk,1}(nn,:) = temp(n_fourier);
                else
                    temp_data_cell{ii,jj}{kk,1}(nn,:) = abs(fft( data_cell{ii,jj}{kk,1}(nn,:),n_fourier));
                end
                
            end
            dist_mat  = squareform(pdist(new_data_cell{ii,jj}{kk,1}));
            epsilon   = median(dist_mat(:));
            new_data_cell{ii,jj}{kk,1} = exp(-dist_mat / ( epsilon));
%             new_data_cell{ii,jj}{kk,1} = cov_of_rows(new_data_cell{ii,jj}{kk,1});

        end
    end
end