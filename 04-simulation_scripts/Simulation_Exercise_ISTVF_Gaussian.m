%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Simulation_Exercise_ISTVF_Gaussian - The code is to simulate sequences
% using ISTVF/SequantialPCA/MVG model descripbed in Sec. 4.3 using Exercise
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
    Result.metrics = zeros(1, 11);      % Your 5 metrics
    Result.params = struct();

    %% Load data
    filename = sprintf('../01_data/MotionNew_Outcome_800.mat');   
    load(filename, 'X','tree')  
    M = size(X,2);
    [~,Ty,~] = size(X{1});

    Result.RawData = X;
    %% ITVF
    [CIS,V_ref,W_ref,mpos,Xc,Yc] = FormISTVF(X);
    Result.CenteredData = Xc;
    %% PCA
    D1 = 10;
    [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,D1);

    %% Full FPCA
    % Set # of coefficients
    D2 = 30;
    [Uf,Vf,Mf,Sf] = FullfPCA(ZZ,D2);

    %% Generation  
    % Multivariate Gaussian Distribution
    SnewG = GaussGeneration(Sf,num_sim,0);
        
    %% Reconstruction
    % Multivariate Gaussian
    Cnew = PCAReconstruction(SnewG,Uf,Mf,UdZ,MuZ);
    [Xnew,Ynew,Cnew] = ISTVF_to_posture(Cnew,V_ref,W_ref,mpos);

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
    save_path = sprintf('../06_results/ExerciseData/ISTVF/run_%d.mat', r);
    save(save_path, 'Result');
end
