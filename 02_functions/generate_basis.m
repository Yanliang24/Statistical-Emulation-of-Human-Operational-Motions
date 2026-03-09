%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate_basis - The code is to generate orthonormal basis in the tangent space at Posture
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [V,W] = generate_basis(Posture)

    [n, p] = size(Posture);
    V = zeros(n, p);
    W = zeros(n, p);

    for i = 1:n
        z = null(Posture(i, :)); 
        z = z';
        V(i, :) = z(1, :);
        W(i, :) = z(2, :);

    end
