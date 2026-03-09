%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cross_sectional_variance - The code is to compute cross sectional variance of dataset X
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sigma, Sigma] = cross_sectional_variance(X)

[~, Ty, ~] = size(X{1});  
[~, M] = size(X);  
for t = 1:Ty
    mpost = squeeze(X{1}(:,t,:));
    nIter = 25;
    for n = 1:nIter
    %     mpos = squeeze(mseq(:, i, :));
        for m = 1:M
            X_mt = squeeze(X{m}(:, t, :));
            
            V(:,m,:) = InverseExp_At_Posture(mpost,X_mt);
        end
        mpost = Exp_At_Posture(mpost, squeeze(mean(V, 2)));
        lik(n) = sum(V(:).^2);
    end
    Mpos(:,t,:) = mpost;
    
    for m = 1:M
        X_mt = squeeze(X{m}(:, t, :)); 
        V(:,m,:) = InverseExp_At_Posture(mpost,X_mt);
    end
    for i = 1:20
        MPost(i,:,t) = mean(squeeze(V(i,:,:)));
        Cpost(i,:,:) = squeeze(V(i,:,:))'*squeeze(V(i,:,:))/(M-1);
    end
    Cpos{t} = Cpost;
end

for t = 1:Ty
    Sigma(t) = sum(Cpos{t} .* reshape(eye(3), [1, 3, 3]), 'all');
end

sigma = mean(Sigma);


end
