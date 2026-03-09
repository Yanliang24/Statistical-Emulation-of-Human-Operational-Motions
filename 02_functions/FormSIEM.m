function [Cm, V_ref, W_ref,Ref_posture] = FormSIEM(X)

[~,M] = size(X);
[~,Ty,~] = size(X{1});
%% Select Reference Posture
X_Ref = X{1};
Ref_posture = squeeze(X_Ref(:,1,:));
nIter = 25;
for n = 1:nIter
%     mpos = squeeze(mseq(:, i, :));
    for t = 1:Ty
        X_m = squeeze(X_Ref(:, t, :)); 
        V(:,t,:) = InverseExp_At_Posture(Ref_posture,X_m);
    end
    Ref_posture = Exp_At_Posture(Ref_posture, squeeze(mean(V, 2)));
    
    lik(n) = sum(V(:).^2);
end
    
%% SIEM
for m = 1:M
    Y{m} = TangentF(X{m},Ref_posture);
end

%% Change Basis
[V_ref,W_ref] = generate_basis(Ref_posture);

for m = 1:M
    Yt = Y{m};
for t=1:Ty
    Ct(t,:,:)=[sum(squeeze(Yt(t,:,:)).* V_ref, 2), sum(squeeze(Yt(t,:,:)).*W_ref, 2)];
end
    Cm(:,m,:) = reshape(Ct,[Ty,40]);
end

end