function [new_data_cell] = creating_fourier_cell(data_cell, pick_stims, pick_subj, n_fourier)

new_data_cell = cell(length(pick_stims), length(pick_subj));
temp_data_cell = cell(length(pick_stims), length(pick_subj));

for ii = 1 : length(pick_stims)
    for jj = 1 : length(pick_subj)
        for kk = 1 : length(data_cell{ii,jj})
            N = size(data_cell{ii,jj}{kk,1},1);
            for nn = 1 : N
                if nargin == 3
                    temp = abs(fft( data_cell{ii,jj}{kk,1}(nn,:)));
                    temp_data_cell{ii,jj}{kk,1}(nn,:) = temp(4:80);
                    new_data_cell{ii,jj}{kk,1}(nn,:) = temp(4:80);
                else
                    temp_data_cell{ii,jj}{kk,1}(nn,:) = abs(fft( data_cell{ii,jj}{kk,1}(nn,:),n_fourier));
                end
                
            end
%             temp_data_cell{ii,jj}{kk,1} = (temp_data_cell{ii,jj}{kk,1} - mean(temp_data_cell{ii,jj}{kk,1},2)) ./ std(temp_data_cell{ii,jj}{kk,1},[],2);
%             new_data_cell{ii,jj}{kk,1} = mean(cat(3,mscohere(temp_data_cell{ii,jj}{kk,1}(:,1:4)'),...
%                   cov(temp_data_cell{ii,jj}{kk,1}(:,5:11)'),cov(temp_data_cell{ii,jj}{kk,1}(:,12:27)'),...
%                   cov(temp_data_cell{ii,jj}{kk,1}(:,27:77)')),3);

        end
    end
end