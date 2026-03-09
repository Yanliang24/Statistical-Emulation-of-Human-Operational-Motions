%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% quan_var - The code is to compute quantization variablility
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
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
