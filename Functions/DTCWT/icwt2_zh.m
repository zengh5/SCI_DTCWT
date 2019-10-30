function x = icwt2_zh(a,detail,varargin)
h = detail{1};
v = detail{2};
d = detail{3};
% error(nargchk(5,11,nargin,'struct'))
if isempty(a) && isempty(h) && isempty(v) && isempty(d), x = []; return; end
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
    if ischar(varargin{k})
        switch varargin{k}
           case 'mode'  , dwtEXTM = varargin{k+1};
           case 'shift' , shift = mod(varargin{k+1},2);
        end
        k = k+2;
    else
        sx = varargin{k};
        k = k+1;
    end
end

x = upsconv2(a,{Lo_R,Lo_R2},sx,dwtEXTM,shift)+ ... % Approximation.
    upsconv2(h,{Lo_R,Hi_R2},sx,dwtEXTM,shift)+ ... % Horizontal Detail.
    upsconv2(v,{Hi_R,Lo_R2},sx,dwtEXTM,shift)+ ... % Vertical Detail.
    upsconv2(d,{Hi_R,Hi_R2},sx,dwtEXTM,shift);     % Diagonal Detail.

