%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation_Exercise_GP - The code is to simulate sequences
% using baseline model Gaussain Process descripbed in Sec. 6.2 using Exercise
% dataset
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear
addpath('../02_functions/')
addpath('../03_metrics/')

numRun = 10;      % Number of Runs
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

%% === Load Exercise Dataset ===
filename = sprintf('../01_data/MotionNew_Outcome_800.mat');   
load(filename, 'X','tree')

[~,Ty,~] = size(X{1});

%% === Step 1. Compute SIEM ===
[Cm,V_ref,W_ref,mpos] = FormSIEM(X);

%% === Step 2. Spatial PCA ===
D1 = 10;
[ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);

%% === Step 3. Train SVGP Model ===
pyData = py.numpy.array(ZZ(:).');
pyData = pyData.reshape(int32(size(ZZ,1)), int32(size(ZZ,2)),int32(size(ZZ,3)));
fprintf('Fitting SVGP model (Steps: %d)...\n', trainSteps);
trainedModel = bridge.train_svgp(pyData, int32(trainSteps), "matern12");

for r = 1:numRun            % Loop over runs
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
    load('../03_metrics/posture_modes_new_7.mat','posturemode')
    load('../03_metrics/Estimated_ROW_New.mat', 'KernelVMF')
    result_runs(r,:) = evaluation(X, Xn, tree, KernelVMF, posturemode);
    Xnew(r,:) = Xn;
    
    % Clear Variables
    clear pyResults sim_data Xn;
end

All_Results.mean_score = mean(result_runs);
All_Results.raw_scores = result_runs;
All_Results.simulated = Xnew;
clear trainedModel ZZ X;

%% Save
save('../06_results/ExerciseData/Other/GP_Exercise_Results.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');