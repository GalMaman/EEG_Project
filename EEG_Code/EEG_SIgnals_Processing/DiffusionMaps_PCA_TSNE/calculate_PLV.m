function [PLV_value] = calculate_PLV(x1,x2)
mu = 0.02;
u = mu*x2+(1-mu)*x1;
v = mu*x1+(1-mu)*x2;

h1=hilbert(u);
h2=hilbert(v);
[phase1]=unwrap(angle(h1));
[phase2]=unwrap(angle(h2));
% since the calculation of the hilbert transform requires integration over
% infinite time; 10% of the calculated instantaneous values are discarded
% on each side of every window
% discard 10%
% stept = 2*pi/100; %time 2*pi/1000
% tstart = 0;% tend
% tend = 100;%time
% %  Number of steps
% nit = round((tend-tstart)/stept);
nit = 930;
perc10w =  floor(nit/10);
phase1 = phase1(perc10w:end-perc10w);
phase2 = phase2(perc10w:end-perc10w);

n = 1;
m = 1;
RP=n*phase1-m*phase2; % relative phase
PLV_value=abs(sum(exp(j*RP))/length(RP)); % value
% PLV_value=abs(sum(sign(RP))/length(RP));  % index
