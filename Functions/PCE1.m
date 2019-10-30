% The function is modified based on the 'PCE.m' from the public codes of DDE lab
% (http://dde.binghamton.edu/download/camera_fingerprint/)
% The original output is a struct, whereas the modified function only output the PCE value
function OutPCE = PCE1(C,shift_range,squaresize)

if nargin<3, squaresize = 11; end               % default neighborhood of the peak
if nargin<2, shift_range = [0,0]; end           % default: no shifts (no cropping) considered 
if any(shift_range>=size(C)), 
    shift_range = min(shift_range,size(C)-1);   % all possible shift in at least one dimension 
end 

if C==0;            % the case when cross-correlation C has zero energy (see crosscor2)
    Out.PCE = 0; 
    Out.pvalue = 1; 
    Out.PeakLocation = [0,0];
    return, 
end  

Cinrange = C(end-shift_range(1):end,end-shift_range(2):end);  	
% C(end,end) location corresponds to no shift of the first matrix argument of crosscor2.m
[max_cc, imax] = max(Cinrange(:));
[ypeak, xpeak] = ind2sub(size(Cinrange),imax(1));
peakheight = Cinrange(ypeak,xpeak);
clear Cinrange
Out.PeakLocation = shift_range+[1,1]-[ypeak, xpeak];

C_without_peak = RemoveNeighborhood(C,[ypeak, xpeak],squaresize);
correl = C(end,end);        clear C

% signed PCE, peak-to-correlation energy    (the sign added as of 10/26/2011)
PCE_energy = mean(C_without_peak.*C_without_peak);
OutPCE = peakheight.^2/PCE_energy * sign(peakheight);

end

%----------------------------------------
function Y = RemoveNeighborhood(X,x,ssize)
% Remove a 2-D neighborhood around x=[x1,x2] from matrix X and output a 1-D vector Y
% ssize     square neighborhood has size (ssize x ssize) square
[M,N] = size(X);
radius = (ssize-1)/2;
X = circshift(X,[radius-x(1)+1,radius-x(2)+1]);
Y = X(ssize+1:end,1:ssize);   Y = Y(:);
Y = [Y;X(M*ssize+1:end)'];
end

function [FA,log10FA] = FAfromPCE(pce,search_space)
% Calculates false alarm probability from having peak-to-cross-correlation (PCE) measure of the peak
% pce           PCE measure obtained from PCE.m
% seach_space   number of correlation samples from which the maximum is taken
%  USAGE:   FA = FAfromPCE(31.5,32*32);

% p = 1/2*erfc(sqrt(pce)/sqrt(2));
[p,logp] = Qfunction(sign(pce)*sqrt(abs(pce)));
if pce<50, 
    FA = 1-(1-p).^search_space;
else
    FA = search_space*p;                % an approximation
end

if FA==0,
    FA = search_space*p;   
    log10FA = log10(search_space)+logp*log10(2);
else 
    log10FA = log10(FA);
end    
end

function [Q,logQ] = Qfunction(x)
% Calculates probability of a Gaussian variable N(0,1) taking value larger than x

if x<37.5, 
    Q = 1/2*erfc(x/sqrt(2));
    logQ = log(Q);
else
    Q = 1./sqrt(2*pi)./x.*exp(-(x.^2)/2);
    logQ = -(x.^2)/2 - log(x)-1/2*log(2*pi);
end
end