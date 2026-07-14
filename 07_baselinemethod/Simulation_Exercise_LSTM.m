%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation_Exercise_LSTM - The code is to simulate sequences
% using baseline model LSTM descripbed in Sec. 6.2 using Exercise
% dataset
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear
addpath('../02_functions/')
addpath('../03_metrics/')
num_runs = 10;      % Number of Runs           
rng(123456)         % Random Setting

All_Results = struct(); 

%% === Load Python Functions ===
% Ensure Python is in path
if count(py.sys.path, pwd) == 0
    insert(py.sys.path, int32(0), pwd);
end
% Load LSTM
bridge = py.importlib.import_module('LSTM_workflow');
% py.importlib.reload(bridge);

%% === Load Exercise Dataset ===
filename = sprintf('../01_data/MotionNew_Outcome_800.mat');   
load(filename, 'X','tree')

% Temporary storage for the 10 runs of this specific dataset
result_runs = zeros(num_runs, 11);

for r = 1:num_runs          % Loop over runs;
    fprintf(' - Run %d/10 (Seed: %d)\n', r, r);
    %% === Step 1. Train Model ===
    fprintf('Training model\n');
    trained_model = bridge.train_motion_model(X, r);

    %% === Step 2. Simulation with Specific Seed ===
    % a). Simulation
    py_sims = bridge.simulate_motion(trained_model, X, r, seed_length=100, sim_length=700);
    % b). Convert back to MATLAB
    sim_data = cell(py_sims);
    for m = 1:length(sim_data)
        sim_data{m} = double(sim_data{m});
        sim_data{m} = re_normalize(sim_data{m});
    end
    %% === Step 3. Evaluation ===
    load('../03_metrics/posture_modes_new_7.mat','posturemode')
    load('../03_metrics/Estimated_ROW_New.mat', 'KernelVMF')
    result_runs(r,:) = evaluation(X, sim_data, tree, KernelVMF, posturemode);
    Xnew(r,:) = sim_data;
end

%% === Store Summary and Clean Up ===
% Compute mean of the 10 runs
All_Results.mean_score = mean(result_runs);
All_Results.raw_scores = result_runs;
All_Results.simulated = Xnew;
% Clear large variables before next dataset loop
fprintf('Cleaning up dataset ...\n');
clear X trained_model py_sims sim_data result_runs;

%% Final Save
save('../06_results/ExerciseData/Other/LSTM_Exercise_Results.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');