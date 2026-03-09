%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ReMPCA - The code is to reconstruct MPCA coefficients back to functions (IS-TVF or SIEM)
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X] = ReMPCA(Z,Uf,Mean)

N=ndims(Z)-1;%Order of the tensor sample
Is=size(Z);%32x32x320
numSpl=Is(3);
X = ttm(tensor(Z),Uf,1:N,'t'); 
X = X+repmat(Mean,[ones(1,N), numSpl]);


