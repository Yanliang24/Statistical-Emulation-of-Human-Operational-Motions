%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ParallelTransport_Posture - The code is to parallel transport vector V from tangent space as Posture to Posture 1
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [V_par] = ParallelTransport_Posture(Posture, V, Posture1)

tmp = Posture+Posture1;
w = diag(V*Posture1')./diag(tmp*tmp');
V_par=V-2*diag(w)*(Posture+Posture1);

