function [Z,Mu,Ud,Sigma] = SpatialPCA(X,d)
    
    [Ty,M,D] = size(X);
    X = reshape(X,[Ty*M,D]);
    Mu = mean(X);
    C = cov(X);
    [U,Sigma,V] = svd(C);

    Ud = U(:,1:d);
    Z = (X-Mu)*Ud;
    Z = reshape(Z,[Ty,M,d]);
