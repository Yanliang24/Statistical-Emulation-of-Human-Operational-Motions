%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acc_test - The code is to compute acceleration energy of dataset X
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S] = Acc_test(X)

I = length(X);
for i = 1:I
    A{i} = Acceleration(X{i});
    Si(i) = Acc_norm(A{i});
end

S = mean(Si);
