function [Xn] = IntrinsicGen(X,Rn)

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


for r = 1:Rn
    for t = 1:Ty
        for i = 1:20
            Ct = squeeze(Cpos{t}(i,:,:));
            try 
                V_new(i,:) = mvnrnd(MPost(i,:,t),Ct,1);
            catch ME
                [V,D] = eig(Ct);  
                Ct_new = V*max(D,0)*V';
                V_new(i,:) = mvnrnd(MPost(i,:,t),Ct_new,1);
            end
        end
        Y_new(:,t,:) = Exp_At_Posture(squeeze(Mpos(:,t,:)),V_new);
    end
    Xn{r} = Y_new;
end
