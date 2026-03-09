clear all

addpath('..\MotionCode\')
addpath('..\..\..\..\Project_new\Code_accelaration\')
addpath('..\')
%% Load Data
load ..\Data\RWP_1_Outcome_300.mat 

X = aligned;
Ty = size(X{1}, 2);

[Cm,V_ref,W_ref,mpos] = FormSIEM(X);

rng(123)
%% Add Noise
for m = 1:M
    Xm = X{m};
    for t = 1:Ty
        for i = 1:20
            V_new(i,:) = mvnrnd(zeros(1,3),0.01*eye(3),1);
        end
        X_n(:,t,:) = Exp_At_Posture(squeeze(Xm(:,t,:)),V_new);
    end
    Xn{m} = X_n;
end

[Cn,V_refn,W_refn,mposn] = FormSIEM(Xn);

for m = 1:M
    dn(m) = dist_seq_to_seq(X{m},Xn{m});
end
%% Sequential PCA
% PCA
D1 = 5;
[ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);

% Full FPCA
D2 = 10;
[Uf,Vf,Mf,Sf,ef,ex,SigK] = FullfPCA(ZZ,D2);

CmRe = PCAReconstruction(Sf,Uf,Mf,UdZ,MuZ);
XRe = SIEM_to_posture(CmRe,V_ref,W_ref,mpos);

% Noise Data
Cn_flatten = reshape(Cn,[(Ty)*M,40]);
Zn = (Cn_flatten-MuZ)*UdZ(:,1:D1);
ZZn = reshape(Zn,[Ty,M,D1]);

for k = 1:D1
    Zk = ZZn(:,:,k);
    Sk = (Zk-Mf(k,:)')'*Uf(:,:,k);
    Sn(:,:,k) = Sk;
end

CnRe = PCAReconstruction(Sn,Uf,Mf,UdZ,MuZ);
XnRe = SIEM_to_posture(CnRe,V_ref,W_ref,mpos);
badIdx = cellfun(@(x) ~isreal(x), XnRe);

for m = 1:M
    dpca(m) = dist_seq_to_seq(X{m},XRe{m});
    dpca_n(m) = dist_seq_to_seq(X{m},XnRe{m});
    dpca_nn(m) = dist_seq_to_seq(Xn{m},XnRe{m});
end

%% MPCA
addpath('..\..\tensor_toolbox-v3.6\')
[Zf,Mf,Uf] = SeqMPCA(Cm,75);
CMPCA = double(ReMPCA(Zf,Uf,Mf));
CMPCA = permute(CMPCA,[2,3,1]);
XRe_MPCA = SIEM_to_posture(CMPCA,V_ref,W_ref,mpos);
% noise data
Cn_ctr = permute(Cn, [3,1,2]);
Cn_ctr = Cn_ctr-repmat(Mf,[ones(1,2), 60]); %Centering
Zn_MPCA = ttm(tensor(Cn_ctr),Uf,1:2); %NewFeature;
Zn_MPCA = double(Zn_MPCA);
CnMPCA = double(ReMPCA(Zn_MPCA,Uf,Mf));
CnMPCA = permute(CnMPCA,[2,3,1]);
XnRe_MPCA = SIEM_to_posture(CnMPCA,V_ref,W_ref,mpos);

for m = 1:M
    dmpca(m) = dist_seq_to_seq(X{m},XRe_MPCA{m});
    dmpca_n(m) = dist_seq_to_seq(X{m},XnRe_MPCA{m});
    dmpca_nn(m) = dist_seq_to_seq(Xn{m},XnRe_MPCA{m});
end
%% AE+FPCA
hiddenSize = D1;
Cm_flatten = reshape(Cm, (Ty)*M,[]);
ae = trainAutoencoder(Cm_flatten', hiddenSize, ...
    'DecoderTransferFunction','purelin', ...
    'SparsityRegularization', 1, ...
    'L2WeightRegularization', 0.001, ...
    'SparsityProportion', 0.5, ...
    'MaxEpochs', 500, ...
    'ShowProgressWindow', false);
Z_AE_flattened = encode(ae, Cm_flatten')';
Z_AE = reshape(Z_AE_flattened, Ty, M, []);''

% D2 = 10;
[Uf_AE,Vf_AE,Mf_AE,Sf_AE] = FullfPCA(Z_AE,D2);

for m = 1:M
    for k = 1:D1
        RS = Sf_AE(m,:,k);
        Z_AE_re(:,k,m) = Uf_AE(:,:,k)*RS'+Mf_AE(k,:)';    
    end 
end

Z_AE_re = permute(Z_AE_re, [1,3,2]);
Z_AE_re_flattened = reshape(Z_AE_re, (Ty)*M,[]);

Cm_AE_flanttend = decode(ae,Z_AE_re_flattened')';
Cm_AE = reshape(Cm_AE_flanttend,Ty,M,[]);
XRe_AE = SIEM_to_posture(Cm_AE,V_ref,W_ref,mpos);

% noisy data
Zn_AE_flattened = encode(ae, Cn_flatten')';
Zn_AE = reshape(Zn_AE_flattened, Ty, M, []);

for k = 1:D1
    Zk = Zn_AE(:,:,k);
    Sk = (Zk-Mf_AE(k,:)')'*Uf_AE(:,:,k);
    Sn_AE(:,:,k) = Sk;
end

for m = 1:M
    for k = 1:D1
        RS = Sn_AE(m,:,k);
        Zn_AE_re(:,k,m) = Uf_AE(:,:,k)*RS'+Mf_AE(k,:)';    
    end 
end

Zn_AE_re = permute(Zn_AE_re, [1,3,2]);
Zn_AE_re_flattened = reshape(Zn_AE_re, (Ty)*M,[]);

Cn_AE_flanttend = decode(ae,Zn_AE_re_flattened')';
Cn_AE = reshape(Cn_AE_flanttend,Ty,M,[]);
XnRe_AE = SIEM_to_posture(Cn_AE,V_ref,W_ref,mpos);

for m = 1:M
    dae(m) = dist_seq_to_seq(X{m},XRe_AE{m});
    dae_n(m) = dist_seq_to_seq(X{m},XnRe_AE{m});
    dae_nn(m) = dist_seq_to_seq(Xn{m},XnRe_AE{m});
end

%% VAE+FPCA
opts = struct('latentDim',5);
vae = trainVAE(Cm_flatten, opts);
Z_VAE = double(vae.encode(Cm_flatten));
Z_VAE = reshape(Z_VAE, Ty, M, []);

% D2 = 20;
[Uf_VAE,Vf_VAE,Mf_VAE,Sf_VAE] = FullfPCA(Z_VAE,D2);

for m = 1:M
    for k = 1:D1
        RS = Sf_VAE(m,:,k);
        Z_VAE_re(:,k,m) = Uf_VAE(:,:,k)*RS'+Mf_VAE(k,:)';    
    end 
end

Z_VAE_re = permute(Z_VAE_re, [1,3,2]);
Z_VAE_re_flattened = reshape(Z_VAE_re, (Ty)*M,[]);

Cm_VAE_flanttend = vae.decode(Z_VAE_re_flattened);
Cm_VAE = reshape(Cm_VAE_flanttend,Ty,M,[]);
XRe_VAE = SIEM_to_posture(Cm_VAE,V_ref,W_ref,mpos);

% noisy data
Zn_VAE_flattened = vae.encode(Cn_flatten);
Zn_VAE = reshape(Zn_VAE_flattened, Ty, M, []);

for k = 1:D1
    Zk = Zn_VAE(:,:,k);
    Sk = (Zk-Mf_VAE(k,:)')'*Uf_VAE(:,:,k);
    Sn_VAE(:,:,k) = Sk;
end

for m = 1:M
    for k = 1:D1
        RS = Sn_VAE(m,:,k);
        Zn_VAE_re(:,k,m) = Uf_VAE(:,:,k)*RS'+Mf_VAE(k,:)';    
    end 
end

Zn_VAE_re = permute(Zn_VAE_re, [1,3,2]);
Zn_VAE_re_flattened = reshape(Zn_VAE_re, (Ty)*M,[]);

Cn_VAE_flanttend = vae.decode(Zn_VAE_re_flattened);
Cn_VAE = reshape(Cn_VAE_flanttend,Ty,M,[]);
XnRe_VAE = SIEM_to_posture(Cn_VAE,V_ref,W_ref,mpos);

for m = 1:M
    dvae(m) = dist_seq_to_seq(X{m},XRe_VAE{m});
    dvae_n(m) = dist_seq_to_seq(X{m},XnRe_VAE{m});
    dvae_nn(m) = dist_seq_to_seq(Xn{m},XnRe_VAE{m});
end

[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
% CreateVideo_Compare(X{1},XRe{1},XnRe{1},Xn{1}, len1, tree, 'NoisyData_Compare_PCA', 8, 75)
% CreateVideo_Compare(XnRe{1},XnRe_MPCA{1},XnRe_AE{1},XnRe_VAE{1}, len1, tree, 'NoisyData_Compare_All', 8, 75)
