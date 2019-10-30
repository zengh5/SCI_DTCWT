function [Y,LP]=ZeroMean(X,type)
% function Y=ZeroMeanCol(X,type) subtracts mean from all subsignals of the given type
% X     2-D or 3-D matrix
% type  One of 4 options: 'col', 'row', 'both', 'CFA'  
% Usage: Y=ZeroMean(X,'col') ... Y will have all columns with mean 0.
%        Y=ZeroMean(X,'CFA') ... Y will have all columns, rows, and 4 types of odd/even pixels zero mean.
             
if nargin<2, type='CFA'; end    % default 

[M,N,K] = size(X);
% initialize the output matrix and vectors
% X = single(X); Y = zeros(size(X),'single'); row = zeros(M,K,'single'); col = zeros(K,N,'single');    % if working in single precision
Y = zeros(size(X)); row = zeros(M,K); col = zeros(K,N); cm=0;

% subtract mean from each color channel
for j=1:K, 
    mu(j) = mean2(X(:,:,j));
    X(:,:,j) = X(:,:,j)-mu(j);
end
for j=1:K, 
    row(:,j) = mean(X(:,:,j)')';
    col(j,:) = mean(X(:,:,j));
end

switch type
    case 'col'
        for j=1:K, Y(:,:,j)=X(:,:,j)-ones(M,1)*col(j,:); end
    case 'row'
        for j=1:K, Y(:,:,j)=X(:,:,j)-row(:,j)*ones(1,N); end
    case 'both'
        for j=1:K, Y(:,:,j)=X(:,:,j)-ones(M,1)*col(j,:); end
        for j=1:K, Y(:,:,j)=Y(:,:,j)-row(:,j)*ones(1,N); end    % equal to Y = ZeroMean(X,'row'); Y = ZeroMean(Y,'col');
    case 'CFA'
        for j=1:K, Y(:,:,j)=X(:,:,j)-ones(M,1)*col(j,:); end
        for j=1:K, Y(:,:,j)=Y(:,:,j)-row(:,j)*ones(1,N); end    % equal to Y = ZeroMean(X,'both');
        for j=1:K,
            cm = mean2(Y(1:2:end,1:2:end,j));
            Y(1:2:end,1:2:end,j) = Y(1:2:end,1:2:end,j)-cm;
            Y(2:2:end,2:2:end,j) = Y(2:2:end,2:2:end,j)-cm;
            Y(1:2:end,2:2:end,j) = Y(1:2:end,2:2:end,j)+cm;
            Y(2:2:end,1:2:end,j) = Y(2:2:end,1:2:end,j)+cm;
        end        
    otherwise
        error('Unknown type');
end
% Linear pattern data:
LP.row=row; LP.col=col; LP.mu=mu; LP.checkerboard_mean=cm;