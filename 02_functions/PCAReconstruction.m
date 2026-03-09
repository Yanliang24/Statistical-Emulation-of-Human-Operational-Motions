%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCAReconstruction - The code is to reconstruct sequential PCA coefficients back to functions (IS-TVF or SIEM)
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C,Znew] = PCAReconstruction(S,Uf,Mf,Ud,Mu)
[M,~,D1] = size(S);
for i = 1:M
    for k = 1:D1
        RS = S(i,:,k);
        Znew(:,k,i) = Uf(:,:,k)*RS'+Mf(k,:)';    
    end    
    Ct = Znew(:,:,i)*Ud(:,1:D1)' + Mu;
    C(:,i,:) = Ct;
end

end

