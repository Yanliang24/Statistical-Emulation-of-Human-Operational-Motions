%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SpatialPCA - The code is to perform spatial PCA on IS-TVF or SIEM functions
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Z,Mu,Ud,Sigma] = SpatialPCA(X,d)
    
    [Ty,M,D] = size(X);
    X = reshape(X,[Ty*M,D]);
    Mu = mean(X);
    C = cov(X);
    [U,Sigma,V] = svd(C);

    Ud = U(:,1:d);
    Z = (X-Mu)*Ud;
    Z = reshape(Z,[Ty,M,d]);

