%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dist_posture - The code is to compute the shape distance between posture1 and posture2
% 
% Implemented based on
%   Park, C., Noh, S.D. and Srivastava, A.
%       Data science for motion and time analysis with modern motion sensor data. 
%       Operations Research. 
%
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d] = dist_posture(posture1, posture2)

a1 = posture1;
a2 = posture2;
ss = diag(a1 * a2'); 
ss = sign(ss).* min(abs(ss), 1);
d = sum(acos(ss));
