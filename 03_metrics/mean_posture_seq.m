function [XM] = mean_posture_seq(X)

[~,M] = size(X);
[~, Ty, ~] = size(X{1});  

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
    XM(:,t,:) = mpost;
end
