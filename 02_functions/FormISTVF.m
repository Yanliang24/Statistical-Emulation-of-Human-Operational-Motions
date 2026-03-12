%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FormISTVF - The code is to generate ISTVF functions from the sequences data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [CIS,V_ref,W_ref,mpos,Xc,Yc,Cm] = FormISTVF(X, varargin)

[~,M] = size(X);
[~,Ty,~] = size(X{1});

for m = 1:M
    Y{m} = STVF(X{m});
end

%% Mean Starting Posture
if nargin > 1
    mpos = varargin{1};
else
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
end

%% Transproting to Mean Posture
for m = 1:M
    Ty = size(Y{m}, 1);
    for t = 1:Ty
        X1 = mpos;
        X2 = squeeze(X{m}(:,1,:));
        Yc{m}(t,:,:) = ParallelTransport_Posture(X2, squeeze(Y{m}(t,:,:)), X1);
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


%% Integrate TVF
tm = linspace(0,1,Ty);

for m = 1:M
    CIS(:,m,:)=cumsum(squeeze(Cm(:,m,:)),1);
end

%% Reconstruction
for m = 1:M
    Y1 = Yc{m};
    Xc{m} = STVF_Recon(Y1,mpos);
end

