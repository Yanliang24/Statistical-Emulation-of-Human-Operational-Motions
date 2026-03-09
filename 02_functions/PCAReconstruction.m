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
