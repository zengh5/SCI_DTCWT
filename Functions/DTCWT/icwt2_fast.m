% This function is the bottleneck of the DTCWT. For speed consideration, 
% we modified the function upsconv2() in the wavelet toolboxof Matlab2015.
% The modified code should only for academic purpose.
function x = icwt2_fast(a,detail,varargin)
h = detail{1};
v = detail{2};
d = detail{3};

if ischar(varargin{1})
    [Lo_R,Hi_R] = wfilters(varargin{1},'r'); next = 2;
else
    Lo_R = varargin{1}(:,1); Hi_R = varargin{1}(:,2);  
    Lo_R2 = varargin{2}(:,1); Hi_R2 = varargin{2}(:,2);  
    next = 3;
end

% Check arguments for Size, Shift and Extension.
DWT_Attribute = getappdata(0,'DWT_Attribute');
if isempty(DWT_Attribute) , DWT_Attribute = dwtmode('get'); end
dwtEXTM = DWT_Attribute.extMode; % Default: Extension.
shift   = DWT_Attribute.shift2D; % Default: Shift.
sx = [];
k = next;
while k<=length(varargin)
    sx = varargin{k};
    k = k+1;
end
x = upsconv2_fast(a,{Lo_R,Lo_R2},sx,dwtEXTM,shift)+ ... % Approximation.
    upsconv2_fast(h,{Lo_R,Hi_R2},sx,dwtEXTM,shift)+ ... % Horizontal Detail.
    upsconv2_fast(v,{Hi_R,Lo_R2},sx,dwtEXTM,shift)+ ... % Vertical Detail.
    upsconv2_fast(d,{Hi_R,Hi_R2},sx,dwtEXTM,shift);     % Diagonal Detail.
