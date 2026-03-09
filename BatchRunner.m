clc;
clear

%% Workder Dataset
scripts_to_run = { ...
    'Simulation_Work_ISTVF_Gaussian.m',...
    'Simulation_Work_SIEM_Gaussian.m',...
    './07_baselinemethod/Simulation_Work_PWI.m',...
    './07_baselinemethod/Simulation_Work_VAR.m',...
    './07_baselinemethod/Simulation_Work_PWI.m',...
    './07_baselinemethod/Simulation_Work_GP.m',...
    './07_baselinemethod/Simulation_Work_LSTM.m',...
    './07_baselinemethod/Simulation_Work_GCN_Trans.m'
};

fprintf('Batch process started at %s\n', datestr(now));

for i = 1:length(scripts_to_run)

    current_script = scripts_to_run{i};
    
    try
        fprintf('Starting: %s ... ', current_script);
        
        run(current_script);
        
        fprintf('COMPLETED successfully at %s.\n', datestr(now));
    catch ME
        fprintf('FAILED at %s.\n', datestr(now));
        fprintf('Error in %s: %s\n', current_script, ME.message);
    end
    
    % (Keeping only our loop variables)
    clearvars -except scripts_to_run i; 
    restTime = 300;
    fprintf('Script finished. Cooling down for %d minutes...\n', round(restTime/60));       
    pause(restTime);
end

clear

%% Exercise Dataset
scripts_to_run = { ...
    'Simulation_Exercise_ISTVF_Gaussian.m',...
    'Simulation_Exercise_SIEM_Gaussian.m',...
    './07_baselinemethod/Simulation_Exercise_PWI.m',...
    './07_baselinemethod/Simulation_Exercise_VAR.m',...
    './07_baselinemethod/Simulation_Exercise_PWI.m',...
    './07_baselinemethod/Simulation_Exercise_GP.m',...
    './07_baselinemethod/Simulation_Exercise_LSTM.m',...
    './07_baselinemethod/Simulation_Exercise_GCN_Trans.m'
};

fprintf('Batch process started at %s\n', datestr(now));

for i = 1:length(scripts_to_run)

    current_script = scripts_to_run{i};
    
    try
        fprintf('Starting: %s ... ', current_script);
        
        run(current_script);
        
        fprintf('COMPLETED successfully at %s.\n', datestr(now));
    catch ME
        fprintf('FAILED at %s.\n', datestr(now));
        fprintf('Error in %s: %s\n', current_script, ME.message);
    end
    
    % (Keeping only our loop variables)
    clearvars -except scripts_to_run i; 
    restTime = 300;
    fprintf('Script finished. Cooling down for %d minutes...\n', round(restTime/60));       
    pause(restTime);
end

fprintf('\n--- ALL TASKS PROCESSED ---\n');

clear
%% Two Level Simulation
scripts_to_run = { ...
    './04_simulation_scripts/LevelOneSimulation_IFTVF_IG.m',...
    './04_simulation_scripts/LevelOneSimulation_SIEM_IG.m',...
    './04_simulation_scripts/LevelTwoSimulation_IFTVF_IG.m',...
    './04_simulation_scripts/LevelTwoSimulation_SIEM_IG.m'
};

fprintf('Batch process started at %s\n', datestr(now));

for i = 1:length(scripts_to_run)

    current_script = scripts_to_run{i};
    
    try
        fprintf('Starting: %s ... ', current_script);
        
        run(current_script);
        
        fprintf('COMPLETED successfully at %s.\n', datestr(now));
    catch ME
        fprintf('FAILED at %s.\n', datestr(now));
        fprintf('Error in %s: %s\n', current_script, ME.message);
    end
    
    % (Keeping only our loop variables)
    clearvars -except scripts_to_run i; 
    restTime = 300;
    fprintf('Script finished. Cooling down for %d minutes...\n', round(restTime/60));       
    pause(restTime);
end
