%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SpatialPCARecon - The code is to reconstruct Spatial PCA result back to IS-TVF or SIEM functions
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C] = SpatialPCARecon(Z,Ud,Mu)
    [N,M,D1] = size(Z);
    for i = 1:M  
        Ct = reshape(Z(:, i, :), [N, D1])*Ud(:,1:D1)' + Mu;
        C(:,i,:) = Ct;
    end
end

