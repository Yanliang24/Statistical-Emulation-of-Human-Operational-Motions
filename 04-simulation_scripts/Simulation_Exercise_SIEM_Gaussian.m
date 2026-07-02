%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Simulation_Exercise_SIEM_Gaussian - The code is to simulate sequences
% using SIEM/SequantialPCA/MVG model descripbed in Sec. 4.3 using Exercise
% dataset
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear
addpath('../02_functions/')
addpath('../03_metrics/')
num_runs = 10;
num_sim = 100;
%Random Setting
rng(123456)

for r = 1:num_runs
    Result = struct();
    Result.SimulatedData = cell(1, num_sim); % 5 subclasses
    Result.metrics = zeros(1, 11);      % 11 metrics
    Result.params = struct();

    %% Load Exercise Data
    filename = sprintf('../01_data/MotionNew_Outcome_800.mat');   
    load(filename, 'X','tree')  
    M = size(X,2);
    [~,Ty,~] = size(X{1});
    
    Result.RawData = X;
    %% SIEM
    [Cm,V_ref,W_ref,mpos] = FormSIEM(X);

    %% Spatial PCA
    D1 = 10;
    [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);

    %% Functional PCA
    D2 = 30;
    [Uf,Vf,Mf,Sf] = FullfPCA(ZZ,D2);

    %% Random Generation using Multivariate Gaussian Distribution
    Snew = GaussGeneration(Sf,num_sim,0);

    %% Reconstruction via Sequential PCA and SIEM
    Cnew = PCAReconstruction(Snew,Uf,Mf,UdZ,MuZ);
    [Xnew,Ynew] = SIEM_to_posture(Cnew,V_ref,W_ref,mpos);
    
    Result.SimulatedData = Xnew;

    Result.params.SPCAmean = MuZ;
    Result.params.SPCcom = UdZ;
    Result.params.fPCAmean = Mf;
    Result.params.fPCcom = Uf;
    
    %% Evaluation
    load('../03_metrics/posture_modes_12.mat','posturemode')
    load('../03_metrics/Estimated_ROW_New.mat', 'KernelVMF')

    Result.metrics = evaluation(X, Xnew, tree, KernelVMF,posturemode);

    %% Save
    save_path = sprintf('../06_results/ExerciseData/SIEM/run_%d.mat', r);
    save(save_path, 'Result');
end
