%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% LevelTwoSimulation_SIEM_IG - The code is to generate and test the second
% level simulation(as ground truth) described in Sec. 5.4
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
    %% Step One: Compute SIEM
    [Cm,V_ref,W_ref,mpos] = FormSIEM(X);
    
    %% Train Test Split
    I = randperm(M);
    Ntrain = 0.8*M;
    Ntest = M-Ntrain;
    Xtrain = X(I(1:Ntrain));
    Xtest = X(I(Ntrain+1:M));
    
    Ctrain = Cm(:,I(1:Ntrain),:);
    Ctest = Cm(:,I(Ntrain+1:M),:);

    %% Step Two: Spatial PCA
    D1 = 4;
    [Z,Mu,Ud,~] = SpatialPCA(Ctrain,D1);

    %% Step Three: Function PCA
    % Set # of coefficients
    D2 = 4;
    [Un,Vn,Mn,S,~,~,~] = FullfPCA(Z,D2);
    
    %% Step Four: Random Generation Using SIEM
    %Indepedent Gaussian Distribution
    SnewIG = GaussGeneration(S,Ntest,1);
        
    %Multivariate Gaussian Distribution
    SnewMG = GaussGeneration(S,Ntest,0);

    %% Step Five: Reconstruction to the Posture Sequences
    % Independent Gaussian Distribution
    % Sequential PCA Reconstruction
    CnewIG = PCAReconstruction(SnewIG,Un,Mn,Ud,Mu);
    % SIEM Reconstruction
    [Xig,YnewI] = SIEM_to_posture(CnewIG,V_ref,W_ref,mpos);
    XnewIG(s,:) = Xig;

    % Multivariate Gaussian
    % Sequential PCA Reconstruction
    CnewMG = PCAReconstruction(SnewMG,Un,Mn,Ud,Mu);
    % SIEM Reconstruction
    [Xmg,YnewM] = SIEM_to_posture(CnewMG,V_ref,W_ref,mpos);
    XnewMG(s,:) = Xmg;
                              
    %% Step Six: Random Generation using Intrinsic Representation
    [Xi] = IntrinsicGen(Xtrain,Ntest);
    XnewI(s,:) = Xi;

    %% Distance Matrix & 2 Sample Test
    % SIEM/Independent Gaussian Distributio    
    p1(s) = twosampletest(Xtest,XnewIG(s,:),10000);

    % SIEM/Multi Gaussian Distribution
    p2(s) = twosampletest(Xtest,XnewMG(s,:),10000);

    % SIEM/Intrinsic
    p3(s) = twosampletest(Xtest,XnewI(s,:),10000);
    
    %% Loglikelihood 
    % Loglikelihood For Training Set
    % Compute the PCA Scores
    [Strain,Ztrain] = ScoreGen(Ctrain,Uf,Mf,UdZ,MuZ);
    % Compute the Loglikelihood
    [L] = LogLikeIndepGauss(Strain,Vf);
    Ltrain(s,:) = L;

    % Loglikelihood For Test Set
    % Compute the PCA Scores
    [Stest,Ztest] = ScoreGen(Ctest,Uf,Mf,UdZ,MuZ);
    % Compute the Loglikelihood
    [L] = LogLikeIndepGauss(Stest,Vf);
    Ltest(s,:) = L;

    % Loglikelihood For Independent Gaussian Generated Sequences
    % Compute SIEM
    [Cig,~,~,~] = FormSIEM(Xig);
    % Compute the PCA Scores
    [Sig,Zig] = ScoreGen(Cig,Uf,Mf,UdZ,MuZ);
    % Compute the Loglikelihood
    [L] = LogLikeIndepGauss(Sig,Vf);
    Lig(s,:) = L;

    % Loglikelihood For Multivariate Gaussian Generated Sequences
    [Cmg,~,~,~] = FormSIEM(Xmg);
    % Compute the PCA Scores
    [Smg,Zmg] = ScoreGen(Cmg,Uf,Mf,UdZ,MuZ);
    % Compute the Loglikelihood
    [L] = LogLikeIndepGauss(Smg,Vf);
    Lmg(s,:) = L;

    % Loglikelihood For Intrinsic Generated Sequences
    [Ci,~,~,~] = FormSIEM(Xi);
    % Compute the PCA Scores
    [Si,Zi] = ScoreGen(Ci,Uf,Mf,UdZ,MuZ);
    % Compute the Loglikelihood
    [L] = LogLikeIndepGauss(Si,Vf);
    Li(s,:) = L;

    disp(['Motion ', num2str(s),' completed']);
end

%% Save
save('../06_results/TwoLevelSimulation/LevelTwo/SimLevelTwoTest_SIEM_IG.mat')