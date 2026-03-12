%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Simulation_Work_SIEM_Gaussian - The code is to simulate sequences
% using SIEM/SequantialPCA/MVG model descripbed in Sec. 4.3 using Worker
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
    Result.SimulatedData = cell(5, num_sim); % 5 subclasses
    Result.metrics = zeros(5, 11);      % 11 metrics
    Result.params = struct();
    for s = 1:5
        %% Load data
        filename = sprintf('../01_data/RWP_%d_Outcome_300.mat', s);   
        load(filename, 'aligned','tree')
        X = aligned;   
        M = size(X,2);
        [~,Ty,~] = size(X{1});
        
        Result.RawData(s,:) = X;
        %% SIEM
        [Cm,V_ref,W_ref,mpos] = FormSIEM(X);
    
        %% PCA
        D1 = 10;
        [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);
    
        %% Full FPCA
        D2 = 30;
        [Uf,Vf,Mf,Sf] = FullfPCA(ZZ,D2);
    
        %% Generation

        % Multivariate Gaussian Distribution
        Snew = GaussGeneration(Sf,num_sim,0);
    
        %% Reconstruction
        Cnew = PCAReconstruction(Snew,Uf,Mf,UdZ,MuZ);
        [Xnew,Ynew] = SIEM_to_posture(Cnew,V_ref,W_ref,mpos);
        
        Result.SimulatedData(s,:) = Xnew;

        ClassName = sprintf('class_%d', s);
        Result.params.(ClassName).SPCAmean = MuZ;
        Result.params.(ClassName).SPCcom = UdZ;
        Result.params.(ClassName).fPCAmean = Mf;
        Result.params.(ClassName).fPCcom = Uf;
        
        %% Evaluation
        load('../03_metrics/posture_modes_12.mat','posturemode')
        load('../03_metrics/Estimated_ROW.mat', 'KernelVMF')

        Result.metrics(s,:) = evaluation(X, Xnew, tree, KernelVMF,posturemode);
    end

    %% Save
    save_path = sprintf('../06_results/WorkerData/SIEM/run_%d.mat', r);
    save(save_path, 'Result');
end
