%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Simulation_Work_ISTVF_Gaussian - The code is to simulate sequences
% using ISTVF/SequantialPCA/MVG model descripbed in Sec. 5.3 using Worker
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
    Result.SimulatedData = cell(5, num_sim); % 5 subclasses
    Result.metrics = zeros(5, 11);      % 11 metrics
    Result.params = struct();
    for s = 1:5                     % Loop through 5 motion classes
        %% === Load Worker Data ===
        filename = sprintf('../01_data/RWP_%d_Outcome_300.mat', s);   
        load(filename, 'aligned','tree')
        X = aligned;   
        M = size(X,2);
        [~,Ty,~] = size(X{1});

        Result.RawData(s,:) = X;
        %% === Step 1. Compute ITVF ===
        [CIS,V_ref,W_ref,mpos,Xc,Yc] = FormISTVF(X);
        Result.CenteredData(s,:) = Xc;

        %% === Step 2. Sequential PCA ===
        % Spatial PCA
        D1 = 10;
        [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,D1);    
        % Functional PCA
        D2 = 30;            % Set # of coefficients
        [Uf,Vf,Mf,Sf] = FullfPCA(ZZ,D2);
    
        %% === Step 3. Simulation ===
        %%%% --- 1.  Random Generation using Multivariate Gaussian Distribution ---
        SnewG = GaussGeneration(Sf,num_sim,0);
            
        %%%% --- 2. Reconstruction via Sequential PCA and ISTVF ---
        Cnew = PCAReconstruction(SnewG,Uf,Mf,UdZ,MuZ);
        [Xnew,Ynew,Cnew] = ISTVF_to_posture(Cnew,V_ref,W_ref,mpos);
        
        %%%% --- 3. Save Outputs ---  
        Result.SimulatedData(s,:) = Xnew;
        ClassName = sprintf('class_%d', s);
        Result.params.(ClassName).SPCAmean = MuZ;
        Result.params.(ClassName).SPCcom = UdZ;
        Result.params.(ClassName).fPCAmean = Mf;
        Result.params.(ClassName).fPCcom = Uf;
        
        %% === Step 4. Evaluation ===
        load('../03_metrics/posture_modes_12.mat','posturemode')
        load('../03_metrics/Estimated_ROW.mat', 'KernelVMF')
        Result.metrics(s,:) = evaluation(X, Xnew, tree, KernelVMF,posturemode);
    end

    %% Save
    save_path = sprintf('../06_results/WorkerData/ISTVF/run_%d.mat', r);
    save(save_path, 'Result');
end
