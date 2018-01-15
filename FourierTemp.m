close all

Fs = 1000;
T  = 1;
f0 = 233;
Ts = 1 / Fs;

t = 0 : Ts : T; t(end) = [];
x = cos(2*pi * f0 * t);

N  = length(t);
XF = fft(x);

f  = Fs * linspace(-1/2, 1/2, N+1); f(end) = [];
figure; stem(f, fftshift( abs(XF) ));

f  = Fs * linspace(0, 1, N+1); f(end) = [];
figure; stem(f, abs(XF) );

