%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation_Exercise_GCN_Trans - The code is to simulate sequences
% using baseline model GCN_Transformer descripbed in Sec. 5.2 using Exercise
% dataset
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear
addpath('../02_functions/')
addpath('../03_metrics/')
num_runs = 10;
% Random Setting
rng(123456)

All_Results = struct(); 

% Ensure Python is in path
if count(py.sys.path, pwd) == 0
    insert(py.sys.path, int32(0), pwd);
end
%% Setup
bridge = py.importlib.import_module('GCN_Transformer_workflow');
% py.importlib.reload(bridge);
numRuns = 10;

filename = sprintf('../01_data/MotionNew_Outcome_800.mat');   
load(filename, 'X','tree')
% 1. Load Dataset
numSeqs = size(X,2);
matCond = randn(numSeqs, 5);
pyCond = py.numpy.array(matCond(:).'); % Flatten to row vector
pyCond = pyCond.reshape(int32(numSeqs), int32(5)); % Reshape to original dimensions
% 1. TRAIN ONCE per dataset
fprintf('Training model...\n');
trainedModel = bridge.train_gcn_model(X, pyCond, int32(100), int32(64), int32(10));

result_runs = zeros(numRuns,11);
for r = 1:numRuns
    fprintf('  Simulation Run %d (Seed: %d)...\n', r, r);         
    % 4. Generate Results
    % Using the first 5 as test seeds
    pyResults = bridge.generate_gcn_motion(trainedModel, X, pyCond, int32(100), int32(r));
    
    % 3. Convert and Save
    resCell = cell(pyResults);
    sim_data = cellfun(@(x) double(x), resCell, 'UniformOutput', false);
    
    load('../03_metrics/posture_modes_12.mat','posturemode')
    load('../03_metrics/Estimated_ROW_New.mat', 'KernelVMF')
    result_runs(r,:) = evaluation(X, sim_data, tree, KernelVMF, posturemode);
    Xnew(r,:) = sim_data;
    
    clear pyResults resCell sim_data;
end   

All_Results.mean_score = mean(result_runs);
All_Results.raw_scores = result_runs;
All_Results.simulated = Xnew;
% Clear dataset-specific variables before next file
clear X trainedModel pyCond matCond;

save('../06_results/ExerciseData/Other/GCN_Trans_Exercise_Results.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');