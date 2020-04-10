% 'denC2D_dwt' DEnoise a 2D image with dual-tree Complex wavelet transform.
% The boundery extension mode is controlled as that of the function 'DWT2.m' 
% in Matlab wavelet toolbox.
function y = denC2D_fast(x,sigma)

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 4;
w = cplxdual2D_fast(x,J,Faf,af);
I = sqrt(-1);

% loop thru scales:
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:3         
            C = w{j}{1}{s1}{s2} + I*w{j}{2}{s1}{s2};
            % The idea here is using smaller r in higher decompostion level.
            % However, the difference is marginal according to our
            % experiments.
%             C2 = WaveNoiseabs(C2,T^2);
            C = WaveNoiseabs_r(C,sigma^2,9-floor(j/2)*2);
            w{j}{1}{s1}{s2} = real(C);
            w{j}{2}{s1}{s2} = imag(C);
        end
    end
end

y = icplxdual2D_fast(w,J,Fsf,sf);

