function image_noise = NoiseExtract_nopadding(Im,qmf,sigma,L)            
[M,N] = size(Im);
m = 2^L;
% use padding with mirrored image content 
    minpad=0;    % minimum number of padded rows and columns as well
    nr = ceil((M+minpad)/m)*m;  nc = ceil((N+minpad)/m)*m;  % dimensions of the padded image (always pad 8 pixels or more)
    pr = ceil((nr-M)/2);      % number of padded rows on the top
    prd= floor((nr-M)/2);     % number of padded rows at the bottom
    pc = ceil((nc-N)/2);      % number of padded columns on the left
    pcr= floor((nc-N)/2);     % number of padded columns on the right
    Im = [Im(pr:-1:1,pc:-1:1),     Im(pr:-1:1,:),     Im(pr:-1:1,N:-1:N-pcr+1);
          Im(:,pc:-1:1),           Im,                Im(:,N:-1:N-pcr+1);
          Im(M:-1:M-prd+1,pc:-1:1),Im(M:-1:M-prd+1,:),Im(M:-1:M-prd+1,N:-1:N-pcr+1)];
    % check this: Im = padarray(Im,[nr-M,nc-N],'symmetric');
    
% Precompute noise variance and initialize the output 
NoiseVar = sigma^2;   

wave_trans = zeros(nr,nc); % malloc the memory
% Wavelet decomposition, without redudance 
wave_trans = mdwt(Im,qmf,L);

% Extract the noise from the wavelet coefficients 

for i=1:L
    % indicies of the block of coefficients
    Hhigh = (nc/2+1):nc; Hlow = 1:(nc/2);
    Vhigh = (nr/2+1):nr; Vlow = 1:(nr/2);
   
    % Horizontal noise extraction
    wave_trans(Vlow,Hhigh) = WaveNoise(wave_trans(Vlow,Hhigh),NoiseVar);
         
    % Vertical noise extraction
    wave_trans(Vhigh,Hlow) =  WaveNoise(wave_trans(Vhigh,Hlow),NoiseVar);
      
    % Diagonal noise extraction
    wave_trans(Vhigh,Hhigh) = WaveNoise(wave_trans(Vhigh,Hhigh),NoiseVar);
	
    nc = nc/2; nr = nr/2;
end

% Last, coarest level noise extraction
wave_trans(1:nr,1:nc) = 0;

% Inverse wavelet transform
image_noise=midwt(wave_trans,qmf,L);

% Crop to the original size
image_noise = image_noise(pr+1:pr+M,pc+1:pc+N);
