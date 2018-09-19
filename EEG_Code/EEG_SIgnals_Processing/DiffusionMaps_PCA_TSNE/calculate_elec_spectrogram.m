function [Y] = calculate_elec_spectrogram(X)

N = size(X,1);
Y = [];
for ii = 1 : N
    time_seg = X(ii,:);
    time_seg = abs(fftshift(fft(time_seg)));
    time_seg = buffer(time_seg,20,2);
    mat_seg  = squareform(pdist(time_seg'));
%     mat_seg  = cov_of_rows(time_seg');
    Y        = cat(3, Y, mat_seg);
end