%clear; clc;

addpath('../MotionCode/')
addpath('../02_Functions/')
addpath('../03_Metrics/')
num_runs = 10;
% Random Setting
rng(123456)

All_Results = struct(); 

% Ensure Python is in path
if count(py.sys.path, pwd) == 0
    insert(py.sys.path, int32(0), pwd);
end

bridge = py.importlib.import_module('LSTM_workflow');
% py.importlib.reload(bridge);

filename = sprintf('../01_Data/MotionNew_Outcome_800.mat');   
load(filename, 'X','tree')

%% Train Model
fprintf('Training model');
trained_model = bridge.train_motion_model(X, num_epoch = int32(1000));

% Temporary storage for the 10 runs of this specific dataset
result_runs = zeros(num_runs, 11);

%% Loop over Simulations
for r = 1:num_runs
    fprintf('  - Run %d/10 (Seed: %d)\n', r, r);
    % Run simulation with specific seed
    py_sims = bridge.simulate_motion(trained_model, X, r, seed_length=100, sim_length=700);
    % Convert back to MATLAB (List of NumPy -> Cell of Doubles)
    sim_data = cell(py_sims);
    for m = 1:length(sim_data)
        sim_data{m} = double(sim_data{m});
    end

    load('../04_Models/posture_modes_12.mat','posturemode')
    load('../04_Models/Estimated_ROW_New.mat', 'KernelVMF')
    result_runs(r,:) = evaluation(X, sim_data, tree, KernelVMF, posturemode);
    Xnew(r,:) = sim_data;
end

% 5. Store Summary and Clean Up
% Convert cell to matrix to calculate mean of the 10 runs
All_Results.mean_score = mean(result_runs);
All_Results.raw_scores = result_runs;
All_Results.simulated = Xnew;
% CRITICAL: Clear large variables before next dataset loop
fprintf('Cleaning up dataset ...\n');
clear X trained_model py_sims sim_data result_runs;

% 6. Final Save
save('../06_Result/ExerciseData/Other/LSTM_Exercise_Results_1.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');