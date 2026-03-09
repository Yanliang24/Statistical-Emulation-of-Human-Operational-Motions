%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% twosampletest - The code is to two sample test on dataset X0 and X1
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = twosampletest(X0, X1, itr);
    Na = size(X0,2);
    Nb = size(X1,2);
    X_combine = [X0 X1];
    for i = 1:Na+Nb
        for j = 1:Na+Nb
            if i == j
                d(i,j) = 0;
            elseif i<j
                d(i,j) = dist_seq_to_seq(X_combine{i},X_combine{j});
            else
                d(i,j) = d(j,i);
            end
        end
    end   
    p = ksampletest(d, Na, Nb, itr);
end
