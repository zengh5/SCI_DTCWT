function y = icplxdual2D_fast(w, J, Fsf, sf)

% Inverse Dual-Tree Complex 2D Discrete Wavelet Transform
% 
% USAGE:
%   y = icplxdual2D(w, J, Fsf, sf)
% INPUT:
%   w - wavelet coefficients
%   J - number of stages
%   Fsf - synthesis filters for final stage
%   sf - synthesis filters for preceeding stages
% OUTPUT:
%   y - output array
% See cplxdual2D
%
% WAVELET SOFTWARE AT POLYTECHNIC UNIVERSITY, BROOKLYN, NY
% http://taco.poly.edu/WaveletSoftware/
for j = 1:J
    for m = 1:3
        [w{j}{1}{1}{m} w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m} w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end
% tic
DWT_Attribute = getappdata(0,'DWT_Attribute');
if strcmp(DWT_Attribute.extMode, 'per')
    y = zeros(size(w{1}{1}{1}{1})*2);
else
    y = zeros(size(w{1}{1}{1}{1})*2+2-size(Fsf{1},1));
end
% T2 = toc,
% tic,
for m = 1:2
    for n = 1:2
        lo = w{J+1}{m}{n};
        for j = J:-1:2
            lo = icwt2_fast(lo, w{j}{m}{n}, sf{m}, sf{n}, size(w{j-1}{m}{n}{1}));
        end
        lo = icwt2_fast(lo, w{1}{m}{n}, Fsf{m}, Fsf{n});
        y = y + lo;
    end
end
% T3 = toc,
% normalization
y = y/2;

