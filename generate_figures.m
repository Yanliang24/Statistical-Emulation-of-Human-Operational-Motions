clc;
clear

%% Tables And Figures
scripts_to_run = { ...
    './05_figure_scripts/Flattening_Compare_Figure4_5.m',...
    './05_figure_scripts/PCA_Result_Figure6_7_10.m',...
    './05_figure_scripts/Posture_Validity_KDE_Figure8.m',...
    './05_figure_scripts/Posture_Mode_FIgure9.m',...
    './05_figure_scripts/qqplot_Figure13.m',...
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
