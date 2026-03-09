%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean_posture_sequence - The code is to compute the mean posture sequence
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [XM] = mean_posture_seq(X)

M = size(X, 2);
[N, Ty, P] = size(X{1}); 
XM = zeros(N, Ty, P);

for t = 1:Ty
    mpost = squeeze(X{1}(:,t,:));
    nIter = 25;
    for n = 1:nIter
        V = zeros(N, M, P);
        for m = 1:M
            X_mt = squeeze(X{m}(:, t, :)); 
            V(:,m,:) = InverseExp_At_Posture(mpost,X_mt);
        end
        mpost = Exp_At_Posture(mpost, squeeze(mean(V, 2)));
        lik(n) = sum(V(:).^2);
    end
    XM(:,t,:) = mpost;
end

