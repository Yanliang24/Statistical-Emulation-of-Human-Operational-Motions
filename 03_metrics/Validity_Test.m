%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Validity_Test - The code is to compute perform test of posture validity score and integrity rate
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S, Integrity] = Validity_Test(X, KernelVMF, alpha, tree)
    I = length(X);
    for i = 1:I
        [Si(i), Inte(i)] = Validity_Score_ver4(X{i}, KernelVMF, alpha, tree);
    end
    S = mean(Si);
    Integrity = mean(Inte);
end
