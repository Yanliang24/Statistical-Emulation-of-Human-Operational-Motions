%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sensitive_Analysis_Result_Table_S4 - The code is to generate table 4 
% in Supplementary Material
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
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
