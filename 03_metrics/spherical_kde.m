%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spherical_kde - The code is to estimate the kernel density of a joint
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f_hat, kappa] = spherical_kde(X, kappa, query_points, C3)
    % X: Nx3 data points (unit vectors)
    % kappa: bandwidth (concentration parameter for vMF kernel)
    % query_points: Mx3 points where density is evaluated (unit vectors)
    % f_hat: Mx1 estimated densities

    N = size(X, 1);
    if isempty(kappa)
        % Automatic bandwidth selection (rule of thumb)
        R = norm(mean(X, 1));
        kappa = (N / R)^(1/3);
        fprintf('Auto-selected kappa = %.3f\n', kappa);
    end

    if nargin < 4
        % Normalization constant for vMF in 3D
        C3 = kappa / (4*pi*sinh(kappa));
    end

    % Compute dot products between data and query points
    dot_products = query_points * X';  % MxN matrix

    % Apply vMF kernel
    kernel_values = exp(kappa * dot_products); % MxN matrix

    % Average over all data points
    f_hat = C3 * mean(kernel_values, 2); % Mx1 vector
end
