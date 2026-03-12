%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation_Work_GCN_Trans - The code is to simulate sequences
% using baseline model GCN_Transformer descripbed in Sec. 5.2 using Worker
% dataset
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

for s = 1:5

    filename = sprintf('../01_data/RWP_%d_Outcome_300.mat', s);   
    load(filename, 'aligned','tree')
    % 1. Load Dataset
    numSeqs = size(aligned,2);
    matCond = randn(numSeqs, 5);
    pyCond = py.numpy.array(matCond(:).'); % Flatten to row vector
    pyCond = pyCond.reshape(int32(numSeqs), int32(5)); % Reshape to original dimensions
    % 1. TRAIN ONCE per dataset
    fprintf('Training model...\n');
    trainedModel = bridge.train_gcn_model(aligned, pyCond, int32(30), int32(64), int32(10));
    
    result_runs = zeros(numRuns,11);
    for r = 1:numRuns
        fprintf('  Simulation Run %d (Seed: %d)...\n', r, r);         
        % 4. Generate Results
        % Using the first 5 as test seeds
        pyResults = bridge.generate_gcn_motion(trainedModel, aligned, pyCond, int32(30), int32(r));
        
        % 3. Convert and Save
        resCell = cell(pyResults);
        sim_data = cellfun(@(x) double(x), resCell, 'UniformOutput', false);
        
        load('../03_metrics/posture_modes_12.mat','posturemode')
        load('../03_metrics/Estimated_ROW.mat', 'KernelVMF')
        result_runs(r,:) = evaluation(aligned, sim_data, tree, KernelVMF, posturemode);
        Xnew(r,:) = sim_data;
        
        clear pyResults resCell sim_data;
    end   

    Dataset = strcat('Dataset',num2str(s));
    All_Results.(Dataset).mean_score = mean(result_runs);
    All_Results.(Dataset).raw_scores = result_runs;
    All_Results.(Dataset).simulated = Xnew;
    % Clear dataset-specific variables before next file
    clear aligned trainedModel pyCond matCond;
end

save('../06_results/WorkerData/Other/GCN_Trans_Worker_Results.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');