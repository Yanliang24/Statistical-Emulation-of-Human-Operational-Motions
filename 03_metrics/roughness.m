function [L] = roughness(X)
[~,T,~] = size(X);
L = zeros(1,T-1);
for t = 1:T-1
    V2 = InverseExp_At_Posture(squeeze(X(:,t,:)),squeeze(X(:,t+1,:)));
    L(t) = sum(vecnorm(V2,2,2));
end