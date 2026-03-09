%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FullfPCA - The code is to perform FPCA on each scalar function
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [U,VarX,Xmean,Score,epdf,ex,Sigma] = FullfPCA(X,d)
    [~,~,K] = size(X);
    for k = 1:K
        Xk = X(:,:,k);
        C = cov(Xk');
        Xkmean = mean(Xk,2);
        [Uk,Sk,Vk] = svd(C);    
        Ud = Uk(:,1:d);
        U(:,:,k) = Ud;
        Scorek = (Xk-Xkmean)'*Ud;
        VarX(k,:) = var(Scorek)+eps;
        Xmean(k,:) = Xkmean;
        Score(:,:,k) = Scorek;
        for i = 1:d
            [f1,x1] = ksdensity(Scorek(:,i));
            epdf(:,i,k) = f1;
            ex(:,i,k) = x1;
        end
        Sigma(:,k) = diag(Sk);
    end

end
