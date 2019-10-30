function ret = crosscorr(array1, array2)
% function ret = crosscor2(array1, array2)
% Computes 2D crosscorrelation of 2D arrays
% Function returns DOUBLE type 2D array
% No normalization applied

array1 = double(array1);
array2 = double(array2);
array1 = array1 - mean(array1(:));
array2 = array2 - mean(array2(:));

%%%%%%%%%%%%%%% End of filtering
tilted_array2 = fliplr(array2);     clear array2
tilted_array2 = flipud(tilted_array2);
TA = fft2(tilted_array2);           clear tilted_array2
FA = fft2(array1);                  clear array1
FF = FA .* TA;                      clear FA TA
ret = real(ifft2(FF));
