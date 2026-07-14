%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sensitive_Analysis_Result_Table_S4 - The code is to generate table 4 
% in Supplementary Material
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear

%% === Generate Table S13 ===
table = zeros(4,6);

%%%% --- Load Results of ISTVF ---
run('../04-simulation_scripts/Sensitive_Analysis_ISTVF.m')
table(:,1:3) = RE;

%%%% --- Load Results of SIEM ---
clearvars -except table
run('../04-simulation_scripts/Sensitive_Analysis_SIEM.m')
table(:,4:6) = RE;

clearvars -except table

table
