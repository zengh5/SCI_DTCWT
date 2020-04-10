function y = dyadup_f(x,o)
%DYADUP Dyadic upsampling.
%   DYADUP implements a simple zero-padding scheme very
%   useful in the wavelet reconstruction algorithm.
%
%   Y = DYADUP(X,EVENODD), where X is a vector, returns
%   an extended copy of vector X obtained by inserting zeros.
%   Whether the zeros are inserted as even- or odd-indexed
%   elements of Y depends on the value of positive integer
%   EVENODD:
%   If EVENODD is even, then Y(2k-1) = X(k), Y(2k) = 0.
%   If EVENODD is odd,  then Y(2k-1) = 0   , Y(2k) = X(k).
%
%   Y = DYADUP(X) is equivalent to Y = DYADUP(X,1)
%
%   Y = DYADUP(X,EVENODD,'type') or
%   Y = DYADUP(X,'type',EVENODD) where X is a matrix,
%   return extended copies of X obtained by inserting columns 
%   of zeros (or rows or both) if 'type' = 'c' (or 'r' or 'm'
%   respectively), according to the parameter EVENODD, which
%   is as above.
%
%   Y = DYADUP(X) is equivalent to
%   Y = DYADUP(X,1,'c')
%   Y = DYADUP(X,'type')  is equivalent to
%   Y = DYADUP(X,1,'type')
%   Y = DYADUP(X,EVENODD) is equivalent to
%   Y = DYADUP(X,EVENODD,'c') 
%
%            |1 2|                              |0 1 0 2 0|
%   When X = |3 4|  we obtain:  DYADUP(X,'c') = |0 3 0 4 0|
%
%                     |1 2|                      |1 0 2|
%   DYADUP(X,'r',0) = |0 0|  , DYADUP(X,'m',0) = |0 0 0|
%                     |3 4|                      |3 0 4|
%
%   See also DYADDOWN.

%   M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi 12-Mar-96.
%   Last Revision: 20-Dec-2010.
%   Copyright 1995-2010 The MathWorks, Inc.

% Internal options.
%-----------------
% Y = DYADUP(X,EVENODD,ARG) returns a vector with even length.
% Y = DYADUP([1 2 3],1,ARG) ==> [0 1 0 2 0 3]
% Y = DYADUP([1 2 3],0,ARG) ==> [1 0 2 0 3 0]
% 
% Y = DYADUP(X,EVENODD,TYPE,ARG) ... for a matrix
% For speed consideration, we modified the function in the wavelet toolbox
% of Matlab2015.
%--------------------------------------------------------------
[r,c]   = size(x);
switch o
    case 'col'
        nc = 2*c-1;
        y  = zeros(r,nc);
        y(:,1:2:nc) = x;
        
    case 'row'
        nr = 2*r-1;
        y  = zeros(nr,c);
        y(1:2:nr,:) = x;
        
    case 'm'
        nc = 2*c-1;
        nr = 2*r-1;
        y  = zeros(nr,nc);
        y(1:2:nr,1:2:nc) = x;
    otherwise
        error(message('Wavelet:FunctionArgVal:Invalid_ArgVal'));
end
% end
