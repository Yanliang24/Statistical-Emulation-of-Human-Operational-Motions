%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dist_seq_to_seq - The code is to compute the sequence distance between posture_seq1 and posture_seq2
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d] = dist_seq_to_seq(posture_seq1, posture_seq2)
    T = size(posture_seq1, 2);
    dot_products = sum(posture_seq1 .* posture_seq2, 3);
    dot_products = max(min(dot_products, 1), -1);
    d = sum(acos(dot_products), 'all') / T;
end

    
