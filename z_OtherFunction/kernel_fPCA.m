function [U,VarX,Xmean,Score,Sigma, Sig1, Sig2] = kernel_fPCA(X,d,lambda)
    [T,~,K] = size(X);
    t = linspace(0,1,T);
    W = zeros(T);
    for i = 1:T
        for j = 1:T
            W(i,j) = exp(-lambda*(t(i)-t(j))^2);
        end
    end
    
    for k = 1:K
        Xk = X(:,:,k);
        C = cov(Xk');
        for i = 1:T
            for j = 1:T
                CK(i,j) = C(i,j)*W(i,j);
            end
        end
        Xkmean = mean(Xk,2);
        [Uk,Sk,Vk] = svd(CK);    
        Ud = Uk(:,1:d);
        U(:,:,k) = Ud;
        Scorek = (Xk-Xkmean)'*Ud;
        VarX(k,:) = var(Scorek)+eps;
        Xmean(k,:) = Xkmean;
        Score(:,:,k) = Scorek;
        Sigma(:,k) = diag(Sk);
        Sig1{k} = C;
        Sig2{k} = CK;
    end
end