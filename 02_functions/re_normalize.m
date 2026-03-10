%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% re_normalize - The code is to ensure the simulated posture resides on the
% posture space
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Xnew] = re_normalize(X)
    [N, T, K] = size(X);
    Xnew = zeros(N,T,K);
    for t = 1:T
        Xt = squeeze(X(:,t,:));
        Xtnew = Xt./vecnorm(Xt,2,2);
        Xnew(:,t,:) = Xtnew;
    end
end
