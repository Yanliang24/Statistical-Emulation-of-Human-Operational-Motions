function [Ca,V_ref,W_ref,mpos] = FormAcc(X)

[~,M] = size(X);
[~,Tx,~] = size(X{1});

for m = 1:M
    Y{m} = TVF(X{m});
end
%% Mean Starting Posture
mpos = squeeze(X{1}(:,1,:));
nIter = 25;
for n = 1:nIter
%     mpos = squeeze(mseq(:, i, :));
    for m = 1:M
        X_m = squeeze(X{m}(:, 1, :)); 
        V(:,m,:) = InverseExp_At_Posture(mpos,X_m);
    end
    mpos = Exp_At_Posture(mpos, squeeze(mean(V, 2)));
    
    lik(n) = sum(V(:).^2);
end

%% Transproting to Mean Posture
Ty = size(Y{m}, 1);
for m = 1:M
    for t = 1:Ty
        X1 = mpos;
        X2 = squeeze(X{m}(:,1,:));
        Yc{m}(t,:,:) = ParallelTransport_Posture_1(X2, squeeze(Y{m}(t,:,:)), X1);
    end
end

%% Change Basis
[V_ref,W_ref] = generate_basis(mpos);

for m = 1:M
    Yt = Yc{m};
    for t=1:Ty
        Ct(t,:,:)=[sum(squeeze(Yt(t,:,:)).* V_ref, 2), sum(squeeze(Yt(t,:,:)).*W_ref, 2)];
    end
    Cm(:,m,:) = reshape(Ct,[Ty,40]);
end

Ta = Ty;
Ca = zeros(Ta,M,40);
for m = 1:M
    Cat(1,:) = Cm(1,m,:);
    for t = 2:Ta
        Cat(t,:) = Cm(t,m,:) - Cm(t-1,m,:);
    end
    Ca(:,m,:) = Cat;
end
