%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% generate_all_results - The code is to generate the tables for the
% evaluation results, Table 2 to 6 in the main manuscript and Table 1 to 3
% in the Supplementary Material
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

numMeth = 7;
numMetric = 11;
numRun = 10;

tables = cell(1, numMetric);
for m = 1:numMetric
    tables{m} = zeros(6, numMeth); 
end

Methods = {'ISTVF', 'SIEM','PWI','VAR','GP','LSTM','GCN_Trans'};
%% Worker Data    
for m = 1:numMeth
    meth = Methods{m};
    if m <= 4
        path = strcat('./06_results/WorkerData/', meth,'/');        
        runData = zeros(numRun, 5, numMetric);
        for r = 1:numRun
            fileName = fullfile(path, sprintf('run_%d.mat', r));
            data = load(fileName);
            runData(r, :, :) = data.Result.metrics;
        end
        % Compute mean across the 10 runs
        finalMeans = squeeze(mean(runData, 1));
    else 
        path = strcat('./06_results/WorkerData/Other/');
        fileName = strcat(path, meth, '_Worker_Results.mat');
        data = load(fileName);
        finalMeans = zeros(5, numMetric);        
        for s = 1:5
            subClass = sprintf('Dataset%d', s);
            finalMeans(s, :) = data.All_Results.(subClass).mean_score;
        end
    end
    
    %% Map means to the 11 Tables   
    for i = 1:numMetric
        tables{i}(1:5, m) = finalMeans(:, i);
    end
end

%% Exercise Data  
for m = 1:numMeth
    meth = Methods{m};
    if m <= 4
        path = strcat('./06_results/ExerciseData/', meth,'/');        
        runData = zeros(numRun, 1, numMetric);
        for r = 1:numRun
            fileName = fullfile(path, sprintf('run_%d.mat', r));
            data = load(fileName);
            runData(r, :, :) = data.Result.metrics;
        end
        % Compute mean across the 10 runs
        finalMeans = squeeze(mean(runData, 1))';
    else 
        path = strcat('./06_results/ExerciseData/Other/');
        fileName = strcat(path, meth, '_Exercise_Results.mat');
        data = load(fileName);     
        finalMeans = data.All_Results.mean_score;
    end
    
    %% Map means to the 11 Tables   
    for i = 1:numMetric
        tables{i}(6, m) = finalMeans(:, i);
    end
end