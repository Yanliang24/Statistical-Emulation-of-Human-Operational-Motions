function [Snew] = GaussGeneration(S,Rn,Indep)

[~,D2,D1] = size(S);
SS = reshape(S,[],D1*D2);
MS = mean(SS);
CS = cov(SS);

if Indep == 1
    CS = diag(diag(CS));
end

Snew = zeros(Rn,D2,D1);
for i = 1:Rn  
    RS = mvnrnd(MS,CS,1);
    RS = reshape(RS,D2,D1);
    Snew(i,:,:) = RS;
end

