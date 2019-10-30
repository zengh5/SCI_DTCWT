%%%% codes for reproduce Fig. 6

addpath('Functions')
addpath('Filter')
addpath('Functions\DTCWT')

clean = double(imread('circlesBrightDark.png'));  % We use the pic of Matlab
clean = clean(351:351+127,201:201+127);  % X Fig. 2(a)
perextend = wextend(2,'per',clean,8);
symwextend = wextend(2,'symw',clean,8);
figure,
subplot(121),imshow(uint8(perextend),'border','tight');
title('periodized extension')
subplot(122),imshow(uint8(symwextend),'border','tight');
title('whole point symmetric extension')