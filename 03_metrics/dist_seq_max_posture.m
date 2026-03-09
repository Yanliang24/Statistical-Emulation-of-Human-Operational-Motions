%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dist_seq_max_posture - The code is to compute max posture distance 
% between two sequences posture_seq1 and posture_seq2
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d] = dist_seq_max_posture(posture_seq1, posture_seq2)

T = size(posture_seq1, 2);
di = zeros(1,T);
for i = 1:T
    a1 = squeeze(posture_seq1(:, i, :));
    a2 = squeeze(posture_seq2(:, i, :));
    ss = diag(a1 * a2'); 
    ss = sign(ss).* min(abs(ss), 1);
    di(i) = sum(acos(ss));
end


d = max(di);
