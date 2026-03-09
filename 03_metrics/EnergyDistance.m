%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EnergyDistance - The code is to compute energy distance between two datasets
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [T0, D] = EnergyDistance(X, Xnew) 

Xcom = [X Xnew];
M = size(X,2);
Rn = size(Xnew,2);
for i = 1:M+Rn
    for j = 1:M+Rn
        if i<j
            D(i,j) = dist_seq_to_seq(Xcom{i},Xcom{j});
        elseif i > j
            D(i,j) = D(j,i);
        elseif i == j
            D(i,j) = 0;
        end
    end
end
Na = M;
Nb = Rn;
T0 = (2*sum(D(1:Na,Na+1:Na+Nb),"all")/(Na*Nb)-sum(D(1:Na,1:Na),"all")/(Na*Na)-sum(D(Na+1:Na+Nb,Na+1:Na+Nb),"all")/(Nb*Nb)); 

    
