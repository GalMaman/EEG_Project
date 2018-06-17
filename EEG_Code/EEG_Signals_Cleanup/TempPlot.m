close all

N  = size(F, 2);
Fs = 5000;

M = 2^13;
f = Fs / 2 * linspace(-1, 1, M + 1); f(end) = [];

FF = fft(F, M, 2);

figure; plot(f, log( abs( fftshift(FF(1:20,:), 2)' ) ));

figure; imagesc(log( abs( fftshift(FF(1:20,:), 2) ) ) )