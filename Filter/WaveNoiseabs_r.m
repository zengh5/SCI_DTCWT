function [tc, coefVar]=WaveNoiseabs_r(coef,NoiseVar,r)
% Model each detail wavelet coefficient as conditional Gaussian random
% variable and use several two-dimensional moving windows to estimate the
% variance of each wavelet coefficient in conjunction with a Wiener-type
% denoising filter
%Input: 
%   coef:          Wavelet detailed coefficient at certain level
%   NoiseVar:      Variance of the additive noise
%Output:
%   tc:            Extracted noise coefficient

% Estimate the variance of original noise-free image for each wavelet
% coefficients using the MAP estimation for 4 sizes of square NxN
% neighborhood for N=[3,5,7,9]

tc = abs(coef).^2;
filteredtc = filter2(ones(3,3)/(3*3), tc); % Hui Zeng
coefVar = Threshold(filteredtc, NoiseVar);

for w = 5:2:r
    EstVar = Threshold(filter2(ones(w,w)/(w*w), tc), NoiseVar);
    coefVar = min(coefVar, EstVar);
end

% Wiener filter like attenuation
tc = coef.*coefVar./(coefVar+NoiseVar);
