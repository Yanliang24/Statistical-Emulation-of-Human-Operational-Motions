%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% quan_var - The code is to compute quantization variablility
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Q, QV] = quan_var(X, posturemode, XM)

I = length(X);
for i = 1:I
    YY(i,:) = quantization(X{i},posturemode);
end

YYM = quantization(XM,posturemode);

T = size(XM,2);
Q = mean(sum(YY~=YYM,2)/T);
QV = var(sum(YY~=YYM,2)/T);
