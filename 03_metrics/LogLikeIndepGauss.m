%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LogLikeIndepGauss - The code is to compute log-likelihood of coefficient 
% S using independent Gaussian distribution with mean 0 and variance Vf
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [L] = LogLikeIndepGauss(S,Vf)

[M,D2,D1] = size(S);
L = zeros(1,M);
for i = 1:M
    LR = 0;
    for k = 1:D1
        s = S(i,:,k);
        lr = sum(log(normpdf(s,zeros(1,D2),Vf(k,:))));
        LR = LR+lr;
    end
    L(i) = LR;

end
