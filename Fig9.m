%%%% codes for reproduce Fig. 9. 
%%%% We want to compare the tampering localization performance of DTCWT with
%%%% that of DWT.
% DID image database is available in 
% http://forensics.inf.tu-dresden.de/ddimgdb/publications/imgdbs
% T. Gole and R. Bohme, ��Dresden Image Database for benchmarking
% digital image forensics,�� in Proc. ACM Symp Appl Computing, 2010, pp.
% 1584�C1590.
%% Initialization
clear,clc,close all
dwtmode('symw')
addpath('Functions')
addpath('Filter')
addpath('Functions\DTCWT')
Threshold = 10;
%% Load the camera fingerprint K and the questioned image IxN
% The file of 'FlatFingerprint.mat' is too large to upload. It is
% generated by 42 Flatfield frames from DID []. We provide the urls for
% download these images in 'mat/images-dir-for-FlatFingerprint.txt'
% 
load('mat/FlatFingerprint.mat')
% The 'demo.png' is grayscale verion of 'Pentax_OptioA40_2_31736.JPG' in DID
% [] with rgb2gray() function of Matlab.
IxO = imread('Images/demo.png');
figure,imshow(IxO,'border','tight')           % Fig. 9(a)
% The 'demoPS.png' is forged by duplicating the tower in the 'demo.png'
IxN = double(imread('Images/demoPS.png'));
figure,imshow(uint8(IxN),'border','tight')    % Fig. 9(b)

%% Calculate PCE of the questioned image block by block
[M,N] = size(IxN);
KI = IxN.*Fingerprint;
for row = 1:floor(M/128)
    for column = 1:floor(N/128)
        Ix = IxN(row*128-127:row*128,column*128-127:column*128);
        % the proposed method
        denoised_dtcwt = denC2D_dwt(Ix,1.8);
        Noisex = ZeroMeanTotal(Ix - denoised_dtcwt);
        C = crosscorr(Noisex,KI(row*128-127:row*128,column*128-127:column*128));
        PCE_block(row,column) = PCE1(C);
        % the baseline DWT based method
        Noisex = NoiseExtractFromImage(Ix,2);
        Noisex = WienerInDFT(Noisex,std2(Noisex));
        C = crosscorr(Noisex,KI(row*128-127:row*128,column*128-127:column*128));
        PCE_block_DWT(row,column) = PCE1(C);     
    end
end
%% Show the localization result
figure,imshow(PCE_block_DWT,[0 Threshold])
figure,imshow(PCE_block,[0 Threshold])

% The image blocks whose PCE < Threshold are regarded as suspicious
dethighlightBold(IxN,128,(PCE_block_DWT<Threshold));  % Fig. 9(c)
dethighlightBold(IxN,128,(PCE_block<Threshold));      % Fig. 9(d)

