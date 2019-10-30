function x = Threshold(y,t)
% Threshold -- Apply max(0,y-t) 

res = (y - t);
x = (res + abs(res))/2;

