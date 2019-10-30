%%%% codes for reproduce Fig. 3
%%%% We want to compare the quality of the extracted SPN by DWT and DTCWT.
%%%% High quality SPN means that high similarity with the groud truth SPN.

clc,clear,
close all

addpath('Functions')
addpath('Filter')
addpath('Functions\DTCWT')
clean = double(imread('circlesBrightDark.png'));  % We use the pic of Matlab
clean = clean(351:351+127,201:201+127);  % X Fig. 2(a)
% figure,
% imshow(uint8(clean),'border','tight');
% title('Clean image')
sigma = 4;     
L = 4;                                   % decomposition level
iter = 500;
SimilarityO = zeros(size(clean));
SimilarityD_P = zeros(size(clean));
Similarity = zeros(size(clean));
for i = 1:iter
    SeeProgress(i)
    randn('seed',i);
    Fingerprint = sigma*randn(128);
    imx = clean + Fingerprint;
    
    %%%%%%%%%%%%%   
    qmf = MakeONFilter('Daubechies',8);
    Noisex = NoiseExtract_nopadding(imx,qmf,sigma,L);
    %%%%%%%%%%%%%%%%
    dwtmode('per')
    denoised_dtcwt = denC2D_dwt(imx,sigma);
    Noisex_C2Dper = imx-denoised_dtcwt;    
%     %%%%%%%%%%%%%%%%
    dwtmode('symw')
    denoised_dtcwt = denC2D_dwt(imx,sigma);
    Noisex_C2Dsymw = imx-denoised_dtcwt;

    SimilarityO = SimilarityO + Noisex.*Fingerprint;
    SimilarityD_P = SimilarityD_P + Noisex_C2Dper.*Fingerprint;
    Similarity = Similarity + Noisex_C2Dsymw.*Fingerprint;
end
figure,subplot(131),
     imshow(SimilarityO/iter,[0 20],'border','tight'),
     title('Similarity map with DWT')
subplot(132),
     imshow(SimilarityD_P/iter,[0 20],'border','tight'),
     title('Similarity map with DTCWT(per)')
subplot(133),
     imshow(Similarity/iter,[0 20],'border','tight'),
     title('Similarity map with DTCWT(symw)')