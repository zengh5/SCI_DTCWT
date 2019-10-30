function SeeProgress(i)
% SeeProgress(i) outputs i without performing carriage return
% This function is designed to be used in slow for-loops to show how the calculations progress
% If the first call in the loop is not with i=1, it's convenient to call SeeProgress(1) before the loop.

if i==1 | i==0, fprintf('\n               '); end
de='\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b';
b=num2str(i,8); 
le=length(b); 
fprintf([de(1:2*(le+9)),'*   %d   *\n'],i); 
