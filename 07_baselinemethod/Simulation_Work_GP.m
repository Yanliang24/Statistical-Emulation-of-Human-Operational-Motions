%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation_Work_GP - The code is to simulate sequences
% using baseline model Gaussian Process descripbed in Sec. 6.2 using Worker
% dataset
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear
addpath('../02_functions/')
addpath('../03_metrics/')

numRuns = 10;      % Number of Runs
rng(123456)         % Random Setting 

All_Results = struct(); 

%% === Load Python Functions ===
% Ensure Python is in path
if count(py.sys.path, pwd) == 0
    insert(py.sys.path, int32(0), pwd);
end
% Load GP Model
bridge = py.importlib.import_module('GP_workflow');
% py.importlib.reload(bridge);

numSims = 100;              % Number of Simulation
trainSteps = 3000;          % Trainign Steps

for s = 1:5
    %% === Load Worker Dataset ===
    filename = sprintf('../01_data/RWP_%d_Outcome_300.mat', s);   
    load(filename, 'aligned','tree')
    [~,Ty,~] = size(aligned{1});
    
    %% === Step 1. Compute SIEM ===
    [Cm,V_ref,W_ref,mpos] = FormSIEM(aligned);
    
    %% === Step 2. Spatial PCA ===
    D1 = 10;
    [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);
    
    %% === Step 3. Train SVGP Model ===
    pyData = py.numpy.array(ZZ(:).');
    pyData = pyData.reshape(int32(size(ZZ,1)), int32(size(ZZ,2)),int32(size(ZZ,3)));
    fprintf('Fitting SVGP model Dataset %d (Steps: %d)...\n', s, trainSteps);
    trainedModel = bridge.train_svgp(pyData, int32(trainSteps), "matern12");

    for r = 1:numRuns
        %% === Step 4. Simulation ===
        % a.) Simulation
        fprintf('  Simulation Run %d (Seed: %d)...\n', r, r);           
        pyResults = bridge.sample_svgp(trainedModel, int32(D1), int32(Ty), ...
                                                int32(numSims), int32(r));       
        sim_data = double(pyResults);

        % b). Reconstruction via Spatial PCA and SIEM
        for i = 1:numSims
            Ct = squeeze(sim_data(:,i,:))*UdZ(:,1:10)' + MuZ;
            Cnew(:,i,:) = Ct;
        end
        Xn = SIEM_to_posture(Cnew,V_ref,W_ref,mpos);

        %% === Step 5.. Evaluation ===
        load('../03_metrics/posture_modes_12.mat','posturemode')
        load('../03_metrics/Estimated_ROW.mat', 'KernelVMF')
        result_runs(r,:) = evaluation(aligned, Xn, tree, KernelVMF, posturemode);
        Xnew(r,:) = Xn;

        % Clear Variables
        clear pyResults sim_data Xn;
    end
    
    Dataset = strcat('Dataset',num2str(s));
    All_Results.(Dataset).mean_score = mean(result_runs);
    All_Results.(Dataset).raw_scores = result_runs;
    All_Results.(Dataset).simulated = Xnew;
    
    % Clear Variables
    clear trainedModel ZZ aligned;
end

%% Save
save('../06_results/WorkerData/Other/GP_Worker_Results.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');