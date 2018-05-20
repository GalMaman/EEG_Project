function [Y] = calculate_elec_spectrogram(X)

N = size(X,1);
Y = [];
for ii = 1 : N
    time_seg = buffer(X(ii,:),200,100);
    fft_seg  = abs(fft(time_seg));
    mat_seg  = squareform(pdist(fft_seg'));
    Y        = cat(3, Y, mat_seg);
end

