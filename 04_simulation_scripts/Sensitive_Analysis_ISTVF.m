%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Sensitive_Analysis_ISTVF - The code is to perform sensitive analysis
% described in Supplementray Material Section S5
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear
addpath('../02_functions')

%% === Load Data ===
load ../01_data/RWP_1_Outcome_300.mat 

X = aligned;
Ty = size(X{1}, 2);
RE = zeros(4,3);

%% ==== Step 1. Compute ISTVF of the Original Data ===
[Cm,V_ref,W_ref,mpos,Xc] = FormISTVF(X);

%% === Step 2. Add Random Noise to the Original Data ===
rng(123)
for m = 1:M
    Xm = X{m};
    for t = 1:Ty
        for i = 1:20
            V_new(i,:) = mvnrnd(zeros(1,3),0.001*eye(3),1);
        end
        X_n(:,t,:) = Exp_At_Posture(squeeze(Xm(:,t,:)),V_new);
    end
    Xn{m} = X_n;
end

%% === Step 3. Compute ISTVF of the Noisy Data ===
[Cn,V_refn,W_refn,mposn, Xcn] = FormISTVF(Xn,mpos);

%%%% --- Compute the Distance Between Original and Noisy Sequences as Reference ---
for m = 1:M
    dcn(m) = dist_seq_to_seq(Xc{m},Xcn{m});
end

%% === Step 4. Testing The Reconstruction using Dimension Reduction Tools for Noisy Data ===
%%%% --- I. Test Sequential PCA ---
% --- 1. Sequential PCA Leraned from the Original Data ---
% Spatial PCA
D1 = 5;
[ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);
% Functional PCA
D2 = 10;
[Uf,Vf,Mf,Sf,ef,ex,SigK] = FullfPCA(ZZ,D2);
% Reconstruction of the Original Data via Sequential PCA and ISTVF
CmRe = PCAReconstruction(Sf,Uf,Mf,UdZ,MuZ);
XRe = ISTVF_to_posture(CmRe,V_ref,W_ref,mpos);

% --- 2. Apply the Learned PCA on the Noise Data ---
% a).Spatial PCA 
Cn_flatten = reshape(Cn,[(Ty-1)*M,40]);
Zn = (Cn_flatten-MuZ)*UdZ(:,1:D1);
ZZn = reshape(Zn,[Ty-1,M,D1]);
% b). Funtional PCA
for k = 1:D1
    Zk = ZZn(:,:,k);
    Sk = (Zk-Mf(k,:)')'*Uf(:,:,k);
    Sn(:,:,k) = Sk;
end

% --- 3. Reconstruction via Sequential PCA and ISTVF ---
% a). PCA Recon
CnRe = PCAReconstruction(Sn,Uf,Mf,UdZ,MuZ);
% b). ISTVF Recon
XnRe = ISTVF_to_posture(CnRe,V_ref,W_ref,mpos);
badIdx = cellfun(@(x) ~isreal(x), XnRe);

% --- 4. Compute the Reconstruction Error ---
% a). Compute Reconstruction Error
for m = 1:M
    % Reconstruction Errors of the Original Data
    dpca(m) = dist_seq_to_seq(Xc{m},XRe{m});
    % Reconstruction Errors of the Noisy Data
    dpca_n(m) = dist_seq_to_seq(Xc{m},XnRe{m});
end

% b). Compute The Mean Error
RE(1,1) = mean(dpca);
RE(1,2) = mean(dpca_n);
RE(1,3) = abs(RE(1,1)-RE(1,2));

%%%% --- II. Test MPCA ---
% --- 1. MPCA Leraned from the Original Data ---
% MPCA
addpath('../tensor_toolbox-v3.6/')
[Zf,Mf,Uf] = SeqMPCA(Cm,90);
% Reconstruction of the Original Data via MPCA and ISTVF
CMPCA = double(ReMPCA(Zf,Uf,Mf));
CMPCA = permute(CMPCA,[2,3,1]);
XRe_MPCA = ISTVF_to_posture(CMPCA,V_ref,W_ref,mpos);

% --- 2. Apply the Learned MPCA on the Noise Data ---
Cn_ctr = permute(Cn, [3,1,2]);
Cn_ctr = Cn_ctr-repmat(Mf,[ones(1,2), 60]); %Centering
Zn_MPCA = ttm(tensor(Cn_ctr),Uf,1:2); %NewFeature;
Zn_MPCA = double(Zn_MPCA);

% --- 3. Reconstruction via MPCA and ISTVF ---
% MPCA Recon
CnMPCA = double(ReMPCA(Zn_MPCA,Uf,Mf));
% ISTVF Recon
CnMPCA = permute(CnMPCA,[2,3,1]);
XnRe_MPCA = ISTVF_to_posture(CnMPCA,V_ref,W_ref,mpos);

% --- 4. Compute the Reconstruction Error ---
% a). Compute Reconstruction Error
for m = 1:M
    % Reconstruction Errors of the Original Data
    dmpca(m) = dist_seq_to_seq(Xc{m},XRe_MPCA{m});
    % Reconstruction Errors of the Noisy Data
    dmpca_n(m) = dist_seq_to_seq(Xc{m},XnRe_MPCA{m});
end

% b). Compute The Mean Error
RE(2,1) = mean(dmpca);
RE(2,2) = mean(dmpca_n);
RE(2,3) = abs(RE(2,1)-RE(2,2));

%%%% --- III. Test AE+FPCA ---
% --- 1. AE+FPCA Leraned from the Original Data ---
% a). Train AE
hiddenSize = D1;
Cm_flatten = reshape(Cm, (Ty-1)*M,[]);
ae = trainAutoencoder(Cm_flatten', hiddenSize, ...
    'DecoderTransferFunction','purelin', ...
    'SparsityRegularization', 1, ...
    'L2WeightRegularization', 0.001, ...
    'SparsityProportion', 0.5, ...
    'MaxEpochs', 500, ...
    'ShowProgressWindow', false);
Z_AE_flattened = encode(ae, Cm_flatten')';

% b). FPCA
Z_AE = reshape(Z_AE_flattened, Ty-1, M, []);
[Uf_AE,Vf_AE,Mf_AE,Sf_AE] = FullfPCA(Z_AE,D2);

% c). Reconstruction of the Original Data via AE+FPCA and ISTVF
% FPCA reconstruction
for m = 1:M
    for k = 1:D1
        RS = Sf_AE(m,:,k);
        Z_AE_re(:,k,m) = Uf_AE(:,:,k)*RS'+Mf_AE(k,:)';    
    end 
end
% AE decode
Z_AE_re = permute(Z_AE_re, [1,3,2]);
Z_AE_re_flattened = reshape(Z_AE_re, (Ty-1)*M,[]);
Cm_AE_flanttend = decode(ae,Z_AE_re_flattened')';
% ISTVF reconstruction
Cm_AE = reshape(Cm_AE_flanttend,Ty-1,M,[]);
XRe_AE = ISTVF_to_posture(Cm_AE,V_ref,W_ref,mpos);

% --- 2. Apply the Learned Model on the Noise Data ---
% a). Apply AE
Zn_AE_flattened = encode(ae, Cn_flatten')';
Zn_AE = reshape(Zn_AE_flattened, Ty-1, M, []);
% b). Apply FPCA
for k = 1:D1
    Zk = Zn_AE(:,:,k);
    Sk = (Zk-Mf_AE(k,:)')'*Uf_AE(:,:,k);
    Sn_AE(:,:,k) = Sk;
end

% --- 3. Reconstruction via AE+FPCA and ISTVF ---
% a). FPCA Reconstruction
for m = 1:M
    for k = 1:D1
        RS = Sn_AE(m,:,k);
        Zn_AE_re(:,k,m) = Uf_AE(:,:,k)*RS'+Mf_AE(k,:)';    
    end 
end
% b). AE Decode
Zn_AE_re = permute(Zn_AE_re, [1,3,2]);
Zn_AE_re_flattened = reshape(Zn_AE_re, (Ty-1)*M,[]);
Cn_AE_flanttend = decode(ae,Zn_AE_re_flattened')';
% c). ISTVF Reconstruction
Cn_AE = reshape(Cn_AE_flanttend,Ty-1,M,[]);
XnRe_AE = ISTVF_to_posture(Cn_AE,V_ref,W_ref,mpos);

% --- 4. Compute the Reconstruction Error
% a). Compute Reconstruction Error
for m = 1:M
    % Reconstruction Errors of the Original Data
    dae(m) = dist_seq_to_seq(Xc{m},XRe_AE{m});
    % Reconstruction Errors of the Noisy Data
    dae_n(m) = dist_seq_to_seq(Xc{m},XnRe_AE{m});
end

% b). Compute The Mean Error
RE(3,1) = mean(dae);
RE(3,2) = mean(dae_n);
RE(3,3) = abs(RE(3,1)-RE(3,2));

%%%% --- IV. Test VAE+FPCA ---
% --- 1. VAE+FPCA Leraned from the Original Data ---
% a). Train VAE
opts = struct('latentDim',5);
vae = trainVAE(Cm_flatten, opts);
Z_VAE = double(vae.encode(Cm_flatten));
% b). FPCA 
Z_VAE = reshape(Z_VAE, Ty-1, M, []);
[Uf_VAE,Vf_VAE,Mf_VAE,Sf_VAE] = FullfPCA(Z_VAE,D2);
% c). Reconstruction of the Original Data via VAE+FPCA and ISTVF
% FPCA reconstruction
for m = 1:M
    for k = 1:D1
        RS = Sf_VAE(m,:,k);
        Z_VAE_re(:,k,m) = Uf_VAE(:,:,k)*RS'+Mf_VAE(k,:)';    
    end 
end
% VAE decode
Z_VAE_re = permute(Z_VAE_re, [1,3,2]);
Z_VAE_re_flattened = reshape(Z_VAE_re, (Ty-1)*M,[]);
Cm_VAE_flanttend = vae.decode(Z_VAE_re_flattened);
Cm_VAE = reshape(Cm_VAE_flanttend,Ty-1,M,[]);
% ISTVF Reconstruction
XRe_VAE = ISTVF_to_posture(Cm_VAE,V_ref,W_ref,mpos);

% --- 2. Apply the Learned Model on the Noise Data ---
% a). Apply VAE
Zn_VAE_flattened = vae.encode(Cn_flatten);
Zn_VAE = reshape(Zn_VAE_flattened, Ty-1, M, []);
% b). Apply FPCA
for k = 1:D1
    Zk = Zn_VAE(:,:,k);
    Sk = (Zk-Mf_VAE(k,:)')'*Uf_VAE(:,:,k);
    Sn_VAE(:,:,k) = Sk;
end

% --- 3. Reconstruction via VAE+FPCA and ISTVF ---
% a). FPCA Reconstruction
for m = 1:M
    for k = 1:D1
        RS = Sn_VAE(m,:,k);
        Zn_VAE_re(:,k,m) = Uf_VAE(:,:,k)*RS'+Mf_VAE(k,:)';    
    end 
end

% b). VAE Decode
Zn_VAE_re = permute(Zn_VAE_re, [1,3,2]);
Zn_VAE_re_flattened = reshape(Zn_VAE_re, (Ty-1)*M,[]);
Cn_VAE_flanttend = vae.decode(Zn_VAE_re_flattened);
Cn_VAE = reshape(Cn_VAE_flanttend,Ty-1,M,[]);

% c). ISTVF Reconstruction
XnRe_VAE = ISTVF_to_posture(Cn_VAE,V_ref,W_ref,mpos);

% --- 4. Compute the Reconstruction Error
% a). Compute Reconstruction Error
for m = 1:M
    % Reconstruction Errors of the Original Data
    dvae(m) = dist_seq_to_seq(Xc{m},XRe_VAE{m});
    % Reconstruction Errors of the Noisy Data
    dvae_n(m) = dist_seq_to_seq(Xc{m},XnRe_VAE{m});
end

% b). Compute The Mean Error
RE(4,1) = mean(dvae);
RE(4,2) = mean(dvae_n);
RE(4,3) = abs(RE(4,1)-RE(4,2));

