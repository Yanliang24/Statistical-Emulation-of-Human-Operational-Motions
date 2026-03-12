%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation_Work_GP - The code is to simulate sequences
% using baseline model Gaussian Process descripbed in Sec. 5.2 using Worker
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
bridge = py.importlib.import_module('GP_workflow');
% py.importlib.reload(bridge);
numRuns = 10;
numSims = 100; 
trainSteps = 3000;

for s = 1:5
    filename = sprintf('../01_data/RWP_%d_Outcome_300.mat', s);   
    load(filename, 'aligned','tree')

    [~,Ty,~] = size(aligned{1});

    [Cm,V_ref,W_ref,mpos] = FormSIEM(aligned);

    D1 = 10;
    [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);
    
    pyData = py.numpy.array(ZZ(:).');
    pyData = pyData.reshape(int32(size(ZZ,1)), int32(size(ZZ,2)),int32(size(ZZ,3)));
    fprintf('Fitting SVGP model Dataset %d (Steps: %d)...\n', s, trainSteps);
    trainedModel = bridge.train_svgp(pyData, int32(trainSteps), "matern12");

    for r = 1:numRuns
        fprintf('  Simulation Run %d (Seed: %d)...\n', r, r);   
        
        pyResults = bridge.sample_svgp(trainedModel, int32(D1), int32(Ty), ...
                                                int32(numSims), int32(r));       
        sim_data = double(pyResults);
        for i = 1:numSims
            Ct = squeeze(sim_data(:,i,:))*UdZ(:,1:10)' + MuZ;
            Cnew(:,i,:) = Ct;
        end
        Xn = SIEM_to_posture(Cnew,V_ref,W_ref,mpos);
        load('../03_metrics/posture_modes_12.mat','posturemode')
        load('../03_metrics/Estimated_ROW.mat', 'KernelVMF')
        result_runs(r,:) = evaluation(aligned, Xn, tree, KernelVMF, posturemode);
        Xnew(r,:) = Xn;
        
        clear pyResults sim_data Xn;
    end
    
    Dataset = strcat('Dataset',num2str(s));
    All_Results.(Dataset).mean_score = mean(result_runs);
    All_Results.(Dataset).raw_scores = result_runs;
    All_Results.(Dataset).simulated = Xnew;

    clear trainedModel ZZ aligned;
end

save('../06_results/WorkerData/Other/GP_Worker_Results.mat', 'All_Results');
fprintf('\nAll datasets processed successfully.\n');