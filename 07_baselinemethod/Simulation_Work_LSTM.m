%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Simulation_Work_LSTM - The code is to simulate sequences
% using baseline model LSTM descripbed in Sec. 6.2 using Worker
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

for s = 1:5         % Loop through each Dataset
    %% === Load Worker Dataset ===
    filename = sprintf('../01_data/RWP_%d_Outcome_300.mat', s);   
    load(filename, 'aligned','tree')
    
    fprintf('Training model for dataset %d...\n', s);   
    result_runs = zeros(num_runs, 11);
    
    for r = 1:num_runs          % Loop over Runs
        fprintf('  - Run %d/10 (Seed: %d)\n', r, r);
        %% === Step 1. Train Model ===
        trained_model = bridge.train_motion_model(aligned,r);

        %% === Step 2. Simulation with Specific Seed ===
        % a). Simulation
        py_sims = bridge.simulate_motion(trained_model, aligned, r);        
        % b). Convert back to MATLAB
        sim_data = cell(py_sims);
        for m = 1:length(sim_data)
            sim_data{m} = double(sim_data{m});
            sim_data{m} = re_normalize(sim_data{m});
        end

        %% === Step 3. Evaluation ===
        load('../03_metrics/posture_modes_12.mat','posturemode')
        load('../03_metrics/Estimated_ROW.mat', 'KernelVMF')
        result_runs(r,:) = evaluation(aligned, sim_data, tree, KernelVMF, posturemode);
        Xnew(r,:) = sim_data;     
        clear trainedModel py_sims sim_data;
    end
    
    %% === Store Summary and Clean Up ===
    % Compute mean of the 10 runs
    Dataset = strcat('Dataset',num2str(s));
    All_Results.(Dataset).mean_score = mean(result_runs);
    All_Results.(Dataset).raw_scores = result_runs;
    All_Results.(Dataset).simulated = Xnew;
    % Clear large variables before next dataset loop
    fprintf('Cleaning up dataset %d...\n', s);
    clear aligned trained_model py_sims sim_data result_runs;
end

%% Final Save
save('../06_results/WorkerData/Other/LSTM_Worker_Results.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');