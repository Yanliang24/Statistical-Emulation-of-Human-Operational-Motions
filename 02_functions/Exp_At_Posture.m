%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exp_At_Posture - The code is to map vector V at the tangent space of Posture to the shape space
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

function [Posture1] = Exp_At_Posture(Posture, V)

nF = vecnorm(V, 2, 2);
Fn = V ./ nF;
Fn(nF == 0, :) = 0;

Posture1 = Posture .* cos(nF) + Fn .* sin(nF);
