%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sensitive_Analysis_Result_Table_S4 - The code is to generate table 4 
% in Supplementary Material
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear

table = zeros(4,6);

run('../04-simulation_scripts/Sensitive_Analysis_ISTVF.m')
table(:,1:3) = RE;

clearvars -except table
run('../04-simulation_scripts/Sensitive_Analysis_SIEM.m')
table(:,4:6) = RE;

clearvars -except table

table
