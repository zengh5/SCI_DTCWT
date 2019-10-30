function Noise = NoiseExtractFromImage(image,sigma,color,noZM) 
% -------------------------------------------------------------------------
%%% ----- Parameters ----- %%%
L=4;            % number of wavelet decomposition levels (between 2-5 as well)
% L=1;
if nargin<4, noZM=0;  end
if nargin<3, color=0; end

if ischar(image), X = imread(image); else X = image; clear image, end

[M0,N0,three]=size(X);
    datatype = class(X);
    switch datatype,                    % convert to [0,255]
        case 'uint8',  X = double(X);
        case 'uint16', X = double(X)/65535*255;
    end

qmf = MakeONFilter('Daubechies',8);

if three~=3,
    Noise = NoiseExtract(X,qmf,sigma,L);
else
    Noise = zeros(size(X));
    for j=1:3
        Noise(:,:,j) = NoiseExtract(X(:,:,j),qmf,sigma,L);
    end
    if ~color
        Noise = rgb2gray1(Noise);
    end
end
if noZM
    'not removing the linear pattern';
else
    Noise = ZeroMeanTotal(Noise);
end
Noise = single(Noise);
