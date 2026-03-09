%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% roughness - The code is to compute roughness function (norm of velocity over time)
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [L] = roughness(X)
[~,T,~] = size(X);
L = zeros(1,T-1);
for t = 1:T-1
    V2 = InverseExp_At_Posture(squeeze(X(:,t,:)),squeeze(X(:,t+1,:)));
    L(t) = sum(vecnorm(V2,2,2));
end
