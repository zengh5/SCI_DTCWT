function [Y,LP]=ZeroMeanTotal(X)
% function Y=ZeroMeanTotal(X) subtracts mean from 
%   all black and all white subsets of columns and rows in the checkerboard pattern
% X     2-D or 3-D matrix
             
Y = zeros(size(X));

[Z,LP11] = ZeroMean(X(1:2:end,1:2:end,:),'both');
Y(1:2:end,1:2:end,:) = Z;
[Z,LP12] = ZeroMean(X(1:2:end,2:2:end,:),'both');
Y(1:2:end,2:2:end,:) = Z;
[Z,LP21] = ZeroMean(X(2:2:end,1:2:end,:),'both');
Y(2:2:end,1:2:end,:) = Z;
[Z,LP22] = ZeroMean(X(2:2:end,2:2:end,:),'both');
Y(2:2:end,2:2:end,:) = Z;

LP.d11=LP11; LP.d12=LP12; LP.d21=LP21; LP.d22=LP22; 