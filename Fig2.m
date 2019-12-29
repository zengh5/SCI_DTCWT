%%%% codes for reproduce Fig. 2
%%%% We want to compare DWT with DTCWT in denoising a very simple image.
%%%% If the compiled mdwt.mexw64 is not work in your platform, please
%%%% recompile it with the C++ source in 'Filter\C++source'
clc,clear,
close all

addpath('Functions')
addpath('Filter')
addpath('Functions\DTCWT')
clean = double(imread('circlesBrightDark.png'));  % We use the pic of Matlab
clean = clean(351:351+127,201:201+127);  % X Fig. 2(a)
figure,subplot(221)
imshow(uint8(clean),'border','tight');
title('Clean image')
sigma = 5;    
% set sigma = 20 to highlight the difference between DWT and DTCWT   
L = 4;                                   % decomposition level
randn('seed',1000); 
Fingerprint = sigma*randn(128);
noisy = clean + Fingerprint;             % Y Fig. 2(b)
% figure,
subplot(222),
imshow(uint8(noisy),'border','tight');
title('Noisy image')

qmf = MakeONFilter('Daubechies',8);
Noise = NoiseExtract_nopadding(noisy,qmf,sigma,L);
denoised = noisy -Noise;
% figure,
subplot(223),
imshow(uint8(denoised),'border','tight');      % Fig. 2(c)
title('Denoised image with DWT')

dwtmode('symw')
denoised_dtcwt = denC2D_dwt(noisy,sigma);
subplot(224),
imshow(uint8(denoised_dtcwt),'border','tight'); % Fig. 2(d)
title('Denoised image with DTCWT')
