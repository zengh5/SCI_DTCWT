function y = upsconv2_fast(x,f,s,dwtARG1,dwtARG2)
%UPSCONV2 Upsample and convolution.
%
%   Y = UPSCONV2(X,{F1_R,F2_R},S,DWTATTR) returns the size-S
%   central portion of the one step dyadic interpolation
%   (upsample and convolution) of matrix X using filter F1_R
%   for rows and filter F2_R for columns. The upsample and
%   convolution attributes are described by DWTATTR.

%   M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi 06-May-2003.
%   Last Revision: 23-Feb-2007.
%   Copyright 1995-2007 The MathWorks, Inc.
% This function is the bottleneck of the DTCWT. For speed consideration, 
% we modified the function in the wavelet toolboxof Matlab2015.

% Special case.
if isempty(x) , y = 0; return; end

% Check arguments for Extension and Shift.
switch nargin
    case 4 , % Arg4 is a STRUCT
        perFLAG  = isequal(dwtARG1.extMode,'per');
        dwtSHIFT = mod(dwtARG1.shift2D,2);
    case 5 ,
        perFLAG  = isequal(dwtARG1,'per');
        dwtSHIFT = mod(dwtARG2,2);
end

% Define Size.
lf = length(f{1});
sx = 2*size(x);
% 
if isempty(s)
    if ~perFLAG , 
        s = sx-lf+2; 
    else
        s = sx; 
    end
end
y = upsconv2ONE(x);


    function y = upsconv2ONE(z)
        [r,c]   = size(z);  %%
        % Compute Upsampling and Convolution.
        if ~perFLAG
            y = dyadup_f(z,'row');
            y = conv2(y,f{1}(:),'full');
            y = dyadup_f(y,'col');
            y = conv2(y ,f{2}(:)','full');
            
            % for speed consideration, the original 'y = wkeep2(y,s,'c',dwtSHIFT);'
            % is substitute as the following code
            d = (size(y)-s)/2;
            first = 1+floor(d);
            last = size(y)-ceil(d);
            y = y(first(1):last(1),first(2):last(2));
        else
            y = dyadup(z,'row',0,1);
            y = wextend('addrow','per',y,lf/2);
            y = conv2(y',f{1}(:)','full'); y = y';
            y = y(lf:lf+s(1)-1,:);
            %-------------------------------------------
            y = dyadup(y,'col',0,1);
            y = wextend('addcol','per',y,lf/2);
            y = conv2(y,f{2}(:)','full');
            y = y(:,lf:lf+s(2)-1);
            %-------------------------------------------
            if dwtSHIFT(1)==1 , y = y([2:end,1],:); end
            if dwtSHIFT(2)==1 , y = y(:,[2:end,1]); end
            %-------------------------------------------
        end
    end
end
