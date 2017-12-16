function [new_data_cell] = creating_fourier_cell(data_cell, pick_stims, pick_subj, n_fourier)

new_data_cell = cell(length(pick_stims), length(pick_subj));
for ii = 1 : length(pick_stims)
    for jj = 1 : length(pick_subj)
        for kk = 1 : length(data_cell{ii,jj})
            N = size(data_cell{ii,jj}{kk,1},1);
            for nn = 1 : N
                new_data_cell{ii,jj}{kk,1}(nn,:) = abs(fft( data_cell{ii,jj}{kk,1}(nn,:),n_fourier));
            end
        end
    end
end