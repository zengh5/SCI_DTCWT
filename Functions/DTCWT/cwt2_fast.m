% This function is based on the wavelet toolboxof Matlab2015.
% The code should only for academic purpose.
function [a,hi] = cwt2_fast(x,varargin)
nbIn = nargin;
error(nargchk(2,7,nbIn,'struct'))
if ischar(varargin{1})
    [Lo_D,Hi_D] = wfilters(varargin{1},'d'); next = 2;
else
    Lo_D = varargin{1}; Hi_D = varargin{2}; 
    Lo_D2 = varargin{3}; Hi_D2 = varargin{4}; 
    next = 5;
end

% Check arguments for Extension and Shift.
DWT_Attribute = getappdata(0,'DWT_Attribute');
if isempty(DWT_Attribute) , DWT_Attribute = dwtmode('get'); end
dwtEXTM = DWT_Attribute.extMode; % Default: Extension.
shift   = DWT_Attribute.shift2D; % Default: Shift.
for k = next:2:nbIn-1
    switch varargin{k}
      case 'mode'  , dwtEXTM = varargin{k+1};
      case 'shift' , shift   = mod(varargin{k+1},2);
    end
end

% Compute sizes.
lf = length(Lo_D);
sx = size(x);

% Extend, Decompose &  Extract coefficients.
first = 2-shift;
flagPer = isequal(dwtEXTM,'per');
if ~flagPer
    sizeEXT = lf-1; last = sx+lf-1;
else
    sizeEXT = lf/2; last = 2*ceil(sx/2);
end
% sizeEXT = 2*sizeEXT;
x = double(x);
% %%%%%%%%%%%
%     y = wextend('addrow',dwtEXTM,x,sizeEXT);
y = [x(sizeEXT+1:-1:2,:);x;x(end-1:-1:end-sizeEXT,:)];

z = conv2(y,Lo_D,'valid');
a = convdown(z,Lo_D2,dwtEXTM,sizeEXT,first,last);
h = convdown(z,Hi_D2,dwtEXTM,sizeEXT,first,last);

z = conv2(y,Hi_D,'valid');
v = convdown(z,Lo_D2,dwtEXTM,sizeEXT,first,last);
d = convdown(z,Hi_D2,dwtEXTM,sizeEXT,first,last);
% %%%%%%%%%%
hi{1} = h;
hi{2} = v;
hi{3} = d;
%-------------------------------------------------------%
% Internal Function(s)
%-------------------------------------------------------%
function y = convdown(x,F,dwtEXTM,lenEXT,first,last)

y = x(first(1):2:last(1),:);
y = wextend('addcol',dwtEXTM,y,lenEXT);
y = conv2(y,F','valid');
y = y(:,first(2):2:last(2));
