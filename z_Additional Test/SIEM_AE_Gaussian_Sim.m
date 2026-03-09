clear all

addpath('..\MotionCode\')
addpath('..\..\..\..\Project_new\Code_accelaration\')
%% Load Data
load ..\Data\RWP_1_Outcome_300.mat 

X = aligned;
[~,Ty,~] = size(X{1});
%% SIEM
[Cm,V_ref,W_ref,mpos] = FormSIEM(X);

hiddenSize = 10;
Cm_flattened = reshape(Cm,Ty*M,[]);

ae = trainAutoencoder(Cm_flattened', hiddenSize, ...
    'DecoderTransferFunction','purelin', ...
    'SparsityRegularization', 1, ...
    'L2WeightRegularization', 0.001, ...
    'SparsityProportion', 0.5, ...
    'MaxEpochs', 500, ...
    'ShowProgressWindow', false);
Z_flattened = encode(ae, Cm_flattened')';
Z = reshape(Z_flattened, Ty, M, []);

D2 = 30;
[Uf,Vf,Mf,Sf,ef,ex,SigK] = FullfPCA(Z,D2);

%% Generation
%Random Setting
rng(123456)
Rn = 100;

% Multivariate Gaussian Distribution
SnewGM = Gauss_Simulation(Sf,Rn,0);
D1 = 10;
%% Reconstruction
% Multivariate Gaussian
for i = 1:Rn
    for k = 1:D1
        RS = SnewGM(i,:,k);
        Znew(:,k,i) = Uf(:,:,k)*RS'+Mf(k,:)';    
    end 
end

Znew2 = permute(Znew, [1,3,2]);
Znew2_flattened = reshape(Znew2, Ty*Rn,[]);

Cnew_flanttend = decode(ae,Znew2_flattened')';
Cnew = reshape(Cnew_flanttend,Ty,Rn,[]);
[Xnew,Ynew] = SIEM_to_posture(Cnew,V_ref,W_ref,mpos);

%% Energy Distance
D = EnergyDistance(X, Xnew(1:60));

%% KNN
a = KNN_test_all(X, Xnew(1:60), 5);

%% Nearest Neighbor Distance 
annd = ANND(X, Xnew(1:60));

%% Mean of Max Distance 
mmd = MMD(X, Xnew(1:60));

%% ANND of Max Posture Distance
mpd = ANND_MP(X, Xnew(1:60));

%% Roughness
R = ANND_R(X, Xnew(1:60));

%% Quantization Varibility
load posture_modes_12.mat

XM = mean_posture_seq(X);
Q0 = quan_var(X, posturemode, XM);

Q = quan_var(Xnew(1:60), posturemode, XM);

%% Posture Validity
load Estimated_ROW.mat 
% load ..\Data\RWP_1_Outcome_300.mat tree

S0 = Validity_Test(X, KernelVMF, 0.05, tree);

S = Validity_Test(Xnew(1:60), KernelVMF, 0.05, tree);

%% Jerk Test
J0 = Jerk_test(X);

J = Jerk_test(Xnew(1:60));
