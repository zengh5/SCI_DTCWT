%%%% codes for reproduce Fig. 5
%%%% We want to show the good directional selectivity of DTCWT.
clear, clc, close all
addpath('Functions')
addpath('Filter')
addpath('Functions\DTCWT')

[af, sf] = farras;
J = 4; 
L = 3*2^(J+1);
N = L/2^J;
x = zeros(L,2*L);
w = dwt2D(x,J,af);
w{J}{1}(N/2,N/2+0*N) = 1;
w{J}{2}(N/2,N/2+1*N) = 1;
y = idwt2D(w,J,sf); 
% Fig.5(a)
figure,
subplot(211),imshow(y,[],'border','tight')
title('two directional selective filters, DWT')

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
x = zeros(2*L,3*L);
w = dualtree2D(x, J, Faf, af);
w{J}{1}{1}(N/2,N/2+0*N) = 1;
w{J}{1}{2}(N/2,N/2+1*N) = 1;
w{J}{1}{3}(N/2,N/2+2*N) = 1;
w{J}{2}{1}(N/2+N,N/2+0*N) = 1;
w{J}{2}{2}(N/2+N,N/2+1*N) = 1;
w{J}{2}{3}(N/2+N,N/2+2*N) = 1;
y = idualtree2D(w, J, Fsf, sf);
% Fig.5(b)
subplot(212),imshow(y,[],'border','tight')
title('six directional selective filters, DTCWT')