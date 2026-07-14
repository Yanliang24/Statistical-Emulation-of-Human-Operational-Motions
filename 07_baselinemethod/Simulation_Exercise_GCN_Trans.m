%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation_Exercise_GCN_Trans - The code is to simulate sequences
% using baseline model GCN_Transformer descripbed in Sec. 6.2 using Exercise
% dataset
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
%clear
addpath('../02_functions/')
addpath('../03_metrics/')

numRuns = 10;              % Number of Runs
rng(123456)                 % Random Setting

All_Results = struct(); 

%% === Load Pythong Functions ===
% Ensure Python is in path
if count(py.sys.path, pwd) == 0
    insert(py.sys.path, int32(0), pwd);
end
% Load GCN_Transformer
bridge = py.importlib.import_module('GCN_Transformer_workflow');
% py.importlib.reload(bridge);

%% === Load Exercise Data ===
filename = sprintf('../01_data/MotionNew_Outcome_800.mat');   
load(filename, 'X','tree')

% Compute Adjacent Matrix
A_mat = eye(20); 
for i = 1:size(tree, 2)
    for j = i+1:size(tree, 2)
        p = tree(:, i);
        c = tree(:, j);

        if ~isempty(intersect(p, c))
            A_mat(i, j) = 1;
            A_mat(j, i) = 1;
        end
    end
end

result_runs = zeros(numRuns,11);
for r = 1:numRuns            % Loop over runs
    fprintf('  Simulation Run %d (Seed: %d)...\n', r, r);  
    %% === Step 1. Training Model ===
    % Conditioning Matrix
    numSeqs = size(X,2);
    matCond = randn(numSeqs, 5);
    pyCond = py.numpy.array(matCond(:).'); % Flatten to row vector
    pyCond = pyCond.reshape(int32(numSeqs), int32(5)); % Reshape to original dimensions

    % Training
    fprintf('Training model...\n');
    trainedModel = bridge.train_gcn_model(X, pyCond, A_mat, int32(100), int32(1), int32(300), r);

    %% === Step 2. Simulation ===
    % a) Simulate Using the first 100 as test seeds
    pyResults = bridge.generate_gcn_motion(trainedModel, X, pyCond, int32(100), int32(r));
    
    % b). Convert and Save
    resCell = cell(pyResults);
    sim_data = cellfun(@(x) double(x), resCell, 'UniformOutput', false);
    for m = 1:length(sim_data)
        sim_data{m} = re_normalize(sim_data{m});
    end
    
    %% === Step 3. Evaluation ===
    load('../03_metrics/posture_modes_new_7.mat','posturemode')
    load('../03_metrics/Estimated_ROW_New.mat', 'KernelVMF')
    result_runs(r,:) = evaluation(X, sim_data, tree, KernelVMF, posturemode);
    Xnew(r,:) = sim_data;
    
    % Clear Variables
    clear pyResults resCell sim_data;
end   

All_Results.mean_score = mean(result_runs);
All_Results.raw_scores = result_runs;
All_Results.simulated = Xnew;
% Clear dataset-specific variables before next file
clear X trainedModel pyCond matCond;

%% Save
save('../06_results/ExerciseData/Other/GCN_Trans_Exercise_Results.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');