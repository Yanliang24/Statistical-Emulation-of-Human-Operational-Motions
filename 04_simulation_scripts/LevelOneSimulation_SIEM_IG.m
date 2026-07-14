%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% LevelOneSimulation_SIEM_IG - The code is to generate first level
% simulation(as ground truth) using SIEM/IG model described in Sec. 7
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear 

addpath('../02_functions/')
addpath('../03_metrics/')

num_runs = 1;           % Number of Independent Runs
num_sim = 1000;         % Number of Simulation
rng(123456)             %Random Setting

for r = 1:num_runs
    Result = struct();
    Result.SimulatedData = cell(5, num_sim); % 5 subclasses
    Result.metrics = zeros(5, 11);      % 11 metrics
    Result.params = struct();
    for s = 1:5
        %% === Load data ===
        filename = sprintf('../01_data/RWP_%d_Outcome_300.mat', s);   
        load(filename, 'aligned','tree')
        X = aligned;   
        M = size(X,2);
        [~,Ty,~] = size(X{1});
        
        Result.RawData(s,:) = X;
        %% === Step One: Compute SIEM ===
        [Cm,V_ref,W_ref,mpos] = FormSIEM(X);
    
        %% === Step Two: Perform Spatial PCA ===
        D1 = 4;
        [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);
    
        %% === Step Three: Perform Functional PCA ===
        D2 = 5;
        [Uf,Vf,Mf,Sf] = FullfPCA(ZZ,D2);
    
        %% === Step Four: Random Generation using Independnet Gaussian Distribution ===
        Snew = GaussGeneration(Sf,num_sim,1);
    
        %% === Step Five: Reconstruction to the Posture Sequences ===
        % Sequential PCA Reconstruction
        Cnew = PCAReconstruction(Snew,Uf,Mf,UdZ,MuZ);
        % SIEM Reconstruction
        [Xnew,Ynew] = SIEM_to_posture(Cnew,V_ref,W_ref,mpos);
        
        %% Save Data for Testing
        Result.SimulatedData(s,:) = Xnew;

        ClassName = sprintf('class_%d', s);
        Result.params.(ClassName).SPCAmean = MuZ;
        Result.params.(ClassName).SPCcom = UdZ;
        Result.params.(ClassName).fPCAmean = Mf;
        Result.params.(ClassName).fPCcom = Uf;
        Result.params.(ClassName).Variance = Vf;
        Result.params.(ClassName).Score = Sf;

    end

    %% Save
    save_path = sprintf('../06_results/TwoLevelSimulation/LevelOne/SIEM_IG_run_%d.mat', r);
    save(save_path, 'Result');
end
