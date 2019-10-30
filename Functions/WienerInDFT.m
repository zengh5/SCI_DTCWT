function NoiseClean = WienerInDFT(ImNoise,sigma)
% function g = WienerInDFT(ImNoise,sigma) removes periodical patterns (like the blockness) from input noise in frequency domain
%   Used to remove blockness and other artefacts from noise extracted from JPEG images
% INPUT:
%    ImNoise     noise extracted from one images or a camera reference pattern
%    sigma       standard deviation of the noise that we want not to exceed even locally if DFT domain
% OUTPUT:
%    NoiseClean  filtered image noise (or camera reference pattern) - estimate of PRNU

[M,N] = size(ImNoise);

F = fft2(ImNoise);   
% clear ImNoise,
Fmag = abs(F/sqrt(M*N));        %  normalized magnitude

NoiseVar = sigma^2;   
  Fmag1 = WaveNoise(Fmag,NoiseVar);

  fzero = find(Fmag==0); Fmag(fzero)=1; Fmag1(fzero)=0;    clear fzero,
F = F.*Fmag1./Fmag;

% inverse FFT transform
NoiseClean = real(ifft2(F));
