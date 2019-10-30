function [y, y2] = denC2D(x,T)

% % Example
% s1 = double(imread('st.tif'));
% s = s1(:,:,3);
% x = s + 20*randn(size(s));
% T = 40;
% y = denC2D(x,T);
% imagesc(y)
% colormap(gray)
% axis image
% sqrt(mean(mean((y-s).^2)))

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 4;
w = cplxdual2D(x,J,Faf,af);
w2 = w;
I = sqrt(-1);
% loop thru scales:
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:3
            C = w{j}{1}{s1}{s2} + I*w{j}{2}{s1}{s2};
            C = soft(C,T);
            w{j}{1}{s1}{s2} = real(C);
            w{j}{2}{s1}{s2} = imag(C);
            
            C2 = w2{j}{1}{s1}{s2} + I*w2{j}{2}{s1}{s2};
%             C2 = WaveNoiseabs(C2,T^2);
            C2 = WaveNoiseabs_r(C2,T^2,9-floor(j/2)*2);
            w2{j}{1}{s1}{s2} = real(C2);
            w2{j}{2}{s1}{s2} = imag(C2);
        end
    end
end
y = icplxdual2D(w,J,Fsf,sf);
y2 = icplxdual2D(w2,J,Fsf,sf);
