%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Simulation_Exercise_ISTVF_Gaussian - The code is to simulate sequences
% using ISTVF/SequantialPCA/MVG model descripbed in Sec. 5.3 using Exercise
% dataset
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear 
addpath('../02_functions/')
addpath('../03_metrics/')
num_runs = 10;          % Number of Runs
num_sim = 100;          % Number of Simulation
rng(123456)             % Random Setting

for r = 1:num_runs
    Result = struct();
    Result.SimulatedData = cell(1, num_sim); % 5 subclasses
    Result.metrics = zeros(1, 11);      % 11 metrics
    Result.params = struct();

    %% === Load Exercise Data ===
    filename = sprintf('../01_data/MotionNew_Outcome_800.mat');   
    load(filename, 'X','tree')  
    M = size(X,2);
    [~,Ty,~] = size(X{1});

    Result.RawData = X;
    %% === Step 1. ITVF ===
    [CIS,V_ref,W_ref,mpos,Xc,Yc] = FormISTVF(X);
    Result.CenteredData = Xc;

    %% === Step 2. Sequential PCA ===
    % Spatial PCA
    D1 = 10;
    [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,D1);
    % Functional PCA    
    D2 = 30;        % Set # of coefficients
    [Uf,Vf,Mf,Sf] = FullfPCA(ZZ,D2);

    %% === Step 3. Simulation ===
    %%%% --- 1.  Random Generation using Multivariate Gaussian Distribution ---
    SnewG = GaussGeneration(Sf,num_sim,0);
        
    %%%% --- 2. Reconstruction via Sequential PCA and SIEM ---
    Cnew = PCAReconstruction(SnewG,Uf,Mf,UdZ,MuZ);
    [Xnew,Ynew,Cnew] = ISTVF_to_posture(Cnew,V_ref,W_ref,mpos);
    
    %%%% --- 3. Save Outputs --- 
    Result.SimulatedData = Xnew;
    Result.params.SPCAmean = MuZ;
    Result.params.SPCcom = UdZ;
    Result.params.fPCAmean = Mf;
    Result.params.fPCcom = Uf;
    
    %% === Step 4. Evaluation ===
    load('../03_metrics/posture_modes_new_7.mat','posturemode')
    load('../03_metrics/Estimated_ROW_New.mat', 'KernelVMF')
    Result.metrics = evaluation(X, Xnew, tree, KernelVMF,posturemode);

    %% Save
    save_path = sprintf('../06_results/ExerciseData/ISTVF/run_%d.mat', r);
    save(save_path, 'Result');
end
