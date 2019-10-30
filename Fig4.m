%%%% codes for reproduce Fig. 4
%%%% We want to show the shift-invariance of DTCWT.
clear, clc, close all
addpath('Functions')
addpath('Filter')
addpath('Functions\DTCWT')
% 双树复小波的近似平移不变性
% 观察结果图可知，时域平移信号的cwt变换，和原信号cwt变换形状相似，只是空间上平移
% 而dwt不具备此性质
clean = double(imread('circlesBrightDark.png'));  % We use the pic of Matlab
img = clean(351:351+127,201:201+127);  % X Fig. 2(a)
J = 3;                 % number of stages
[Faf, Fsf] = FSfarras; % 1st stage anal. & synth. filters
[af, sf] = dualfilt1;
[af_dwt, sf_dwt] = farras;  % dwt filters
%%%%%%%%%%%% Si
x = img(40,:);      % Test signal
x_L6 = img(44,:);   % x(n-6)
x_zero = zeros(1,128);
figure,
subplot(541),
    plot(x),title('the 40^{th} row of Fig. 2(a)'),axis([0 128 0 280])
subplot(542),
    plot(x_L6),title('the 44^{th} row of Fig. 2(a)'),axis([0 128 0 280])
    

w_zero = dualtree(x_zero, J, Faf, af);
w = dualtree(x, J, Faf, af); 
w_L6 = dualtree(x_L6, J, Faf, af); 
for J_show = 1:J+1 
    w3 = w_zero;
    w3{J_show} = w{J_show};
    
    wL6_3 = w_zero;
    wL6_3{J_show} = w_L6{J_show};
    
    y = idualtree(w3, J, Fsf, sf);
    y_L6 = idualtree(wL6_3, J, Fsf, sf);
   
    maxy= 40*2^(J_show-1);
  
    subplot(5,4,12+J_show),
    plot(y),
    axis([0 128 -maxy maxy])
    subplot(5,4,16+J_show),
    plot(y_L6),
    if J_show <= J
        xlabel(['level ' num2str(J_show)])
    else
        xlabel(['level ' num2str(J) ' scaling'])
    end
    
    axis([0 128 -maxy maxy])
end
%%%%%%%%%%%%%%%%%%%%%%%%
w_zero = dwt(x_zero, J, af_dwt);
w = dwt(x, J, af_dwt); 
w_shift = dwt(x_L6, J, af_dwt);

for J_show = 1:J+1 
w3 = w_zero;
w3{J_show} = w{J_show};

wshift = w_zero;
wshift{J_show} = w_shift{J_show};


y = idwt(w3, J, sf_dwt); 
y_shift = idwt(wshift, J, sf_dwt); 
  
    maxy= 40*2^(J_show-1);

subplot(5,4,4+J_show),
    plot(y),
    axis([0 128 -maxy maxy])
subplot(5,4,8+J_show),
    plot(y_shift),
    axis([0 128 -maxy maxy])
end
