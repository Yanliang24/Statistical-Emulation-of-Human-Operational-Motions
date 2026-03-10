%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LevelTwoSimulation_SIEM_IG - The code is to generate and test the second
% level simulation(as ground truth) described in Sec. 5.4
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear
addpath('../02_functions/')
addpath('../03_metrics/')
num_runs = 1;
%Random Setting
rng(1234)

%% Load Data
load ../06_results/TwoLevelSimulation/LevelOne/SIEM_IG_run_1.mat

X0 = Result.SimulatedData;
[S,M] = size(X0);
for s = 1:S    
    X = X0(s,:);
    ClassName = sprintf('class_%d', s);
    Uf = Result.params.(ClassName).fPCcom;
    Mf = Result.params.(ClassName).fPCAmean;
    UdZ = Result.params.(ClassName).SPCcom;
    MuZ = Result.params.(ClassName).SPCAmean;
    Vf = Result.params.(ClassName).Variance;
    %% SIEM
    [Cm,V_ref,W_ref,mpos] = FormSIEM(X);
    
    %% Train Test Split
    I = randperm(M);
    Ntrain = 0.8*M;
    Ntest = M-Ntrain;
    Xtrain = X(I(1:Ntrain));
    Xtest = X(I(Ntrain+1:M));
    
    Ctrain = Cm(:,I(1:Ntrain),:);
    Ctest = Cm(:,I(Ntrain+1:M),:);

    %% PCA
    D1 = 4;
    [Z,Mu,Ud,~] = SpatialPCA(Ctrain,D1);

    %% Full FPCA
    % Set # of coefficients
    D2 = 4;
    [Un,Vn,Mn,S,~,~,~] = FullfPCA(Z,D2);
    
    %% SIEM Generation
    %Indepedent Gaussian Distribution
    SnewIG = GaussGeneration(S,Ntest,1);
        
    %Multivariate Gaussian Distribution
    SnewMG = GaussGeneration(S,Ntest,0);

    %% Reconstruction
    % Independent Gaussian
    CnewIG = PCAReconstruction(SnewIG,Un,Mn,Ud,Mu);
    [Xig,YnewI] = SIEM_to_posture(CnewIG,V_ref,W_ref,mpos);
    XnewIG(s,:) = Xig;

    % Multivariate Gaussian
    CnewMG = PCAReconstruction(SnewMG,Un,Mn,Ud,Mu);
    [Xmg,YnewM] = SIEM_to_posture(CnewMG,V_ref,W_ref,mpos);
    XnewMG(s,:) = Xmg;
                              
    %% Intrinsic Generation
    [Xi] = IntrinsicGen(Xtrain,Ntest);
    XnewI(s,:) = Xi;

    %% Distance Matrix & 2 Sample Test
    % Independent Gaussian Distributio    
    p1(s) = twosampletest(Xtest,XnewIG(s,:),10000);

    % Multi Gaussian Distribution
    p2(s) = twosampletest(Xtest,XnewMG(s,:),10000);

    % Intrinsic
    p3(s) = twosampletest(Xtest,XnewI(s,:),10000);
    
    %% Loglikelihood 
    % Traning
    [Strain,Ztrain] = ScoreGen(Ctrain,Uf,Mf,UdZ,MuZ);
    [L] = LogLikeIndepGauss(Strain,Vf);
    Ltrain(s,:) = L;

    % Test
    [Stest,Ztest] = ScoreGen(Ctest,Uf,Mf,UdZ,MuZ);
    [L] = LogLikeIndepGauss(Stest,Vf);
    Ltest(s,:) = L;

    % Independent Gaussian Generated
    [Cig,~,~,~] = FormSIEM(Xig);
    [Sig,Zig] = ScoreGen(Cig,Uf,Mf,UdZ,MuZ);
    [L] = LogLikeIndepGauss(Sig,Vf);
    Lig(s,:) = L;

    % Multivariate Gaussian Generated
    [Cmg,~,~,~] = FormSIEM(Xmg);
    [Smg,Zmg] = ScoreGen(Cmg,Uf,Mf,UdZ,MuZ);
    [L] = LogLikeIndepGauss(Smg,Vf);
    Lmg(s,:) = L;

    % Intrinsic Generated
    [Ci,~,~,~] = FormSIEM(Xi);
    [Si,Zi] = ScoreGen(Ci,Uf,Mf,UdZ,MuZ);
    [L] = LogLikeIndepGauss(Si,Vf);
    Li(s,:) = L;

    disp(['Motion ', num2str(s),' completed']);
end

%% Save
save('../06_results/TwoLevelSimulation/LevelTwo/SimLevelTwoTest_SIEM_IG.mat')