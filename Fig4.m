%%%% codes for reproduce Fig. 4
%%%% We want to show the shift-invariance of DTCWT.

clear, clc, close all
addpath('Functions')
addpath('Filter')
addpath('Functions\DTCWT')
% 
%%% Load image and set the parameters needed
% We use the pic of Matlab
clean = double(imread('circlesBrightDark.png'));  
% Fig. 2(a)
img = clean(351:351+127,201:201+127);
% number of stages
J = 3; 
% cwt filters
[Faf, Fsf] = FSfarras; 
[af, sf] = dualfilt1;
% dwt filters
[af_dwt, sf_dwt] = farras;  

%%% We take the 40th row and the 44th row of Fig. 2(a) as an example.
%%% It is observed that the 44th row is roughly a 2-pixel right-shift version of the 40th row. 
x = img(40,:);        % Test signal
xshift = img(44,:);   % roughly x(n-2)
x_zero = zeros(1,128);% Zero signal
figure,
subplot(541),
    plot(x),title('the 40^{th} row of Fig. 2(a)'),axis([0 128 0 280])
subplot(542),
    plot(xshift),title('the 44^{th} row of Fig. 2(a)'),axis([0 128 0 280])

    
%%% Forward CWT transform
%%% Zero signal is used to generate the structure of CWT decomposition
w_zero = dualtree(x_zero, J, Faf, af);
w = dualtree(x, J, Faf, af); 
wshift = dualtree(xshift, J, Faf, af); 
for J_show = 1:J+1 
    % Only the J_show stage coefficients are used for reconstruction
    w3 = w_zero;
    w3{J_show} = w{J_show};
    
    wshift_3 = w_zero;
    wshift_3{J_show} = wshift{J_show};
    
    % CWT reconstruction
    y = idualtree(w3, J, Fsf, sf);
    yshift = idualtree(wshift_3, J, Fsf, sf);
   
    % show the fourth and the fifth row of plots
    maxy= 40*2^(J_show-1);
    subplot(5,4,12+J_show), 
    plot(y),
    axis([0 128 -maxy maxy])
    
    subplot(5,4,16+J_show),
    plot(yshift),
    if J_show <= J
        xlabel(['level ' num2str(J_show)])
    else
        xlabel(['level ' num2str(J) ' scaling'])
    end
    axis([0 128 -maxy maxy])
end
%%% In each stage, it is observed that reconstructured signal of the 44th row is roughly 
%%% a shift version of that of the 40th row. This is the shift-invariance of DTCWT


%%%%%Forward DWT transform
%%% Zero signal is used to generate the structure of DWT decomposition
w_zero = dwt(x_zero, J, af_dwt);
w = dwt(x, J, af_dwt); 
wshift = dwt(xshift, J, af_dwt);

for J_show = 1:J+1 
    w3 = w_zero;
    w3{J_show} = w{J_show};
    wshift_3 = w_zero;
    wshift_3{J_show} = wshift{J_show};
    
    % DWT reconstruction   
    y = idwt(w3, J, sf_dwt);
    yshift = idwt(wshift_3, J, sf_dwt);
    
    % show the second and the third row of plots
    maxy= 40*2^(J_show-1);    
    subplot(5,4,4+J_show),
    plot(y),
    axis([0 128 -maxy maxy])
    subplot(5,4,8+J_show),
    plot(yshift),
    axis([0 128 -maxy maxy])
end
%%% For some stages,the reconstructured signal of the 44th row is no longer 
%%% a shift version of that of the 40th row. 