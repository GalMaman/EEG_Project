function [new_data_cell] = creating_PLV_cell(data_cell, pick_stims, pick_subj, norm_data)

new_data_cell = cell(length(pick_stims), length(pick_subj));
num_channels  = size(data_cell{1,1}{1,1},1);

for ii = 1:length(pick_stims)
    for jj = 1:length(pick_subj)
        for kk = 1:length(data_cell{ii,jj})
            if norm_data == 1 
                data_cell{ii,jj}{kk,1} = (data_cell{ii,jj}{kk,1} - mean(data_cell{ii,jj}{kk,1},2)) ./ std(data_cell{ii,jj}{kk,1},[],2);
            end
            M = zeros(num_channels,num_channels);
            for mm = 1 : num_channels
%                 for nn = mm + 1 : num_channels
                for nn = 1 : num_channels
                    M(mm,nn) = calculate_PLV(data_cell{ii,jj}{kk,1}(mm,:),data_cell{ii,jj}{kk,1}(nn,:));
                end
            end
%             M = temp;
%             [U, L] = eig(M);
%             vL = diag(L);
%             vL(vL < 0.1) = 0.1;
%             M = (U .* vL') * U';
%             temp = temp + temp';
%             new_data_cell{ii,jj}{kk,1} = temp * temp';
            [L,d,~,~] = mcholmz(M);
            M         = L * diag(d) * L';
            new_data_cell{ii,jj}{kk,1} = M;
        end
    end
end