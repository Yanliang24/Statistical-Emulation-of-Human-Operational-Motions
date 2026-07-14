%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% two_level_simulation_results - The code is to generate the tables for the
% data emulation results, Table 7 in the main manuscript. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

table = zeros(5, 6);

load ./06_results/TwoLevelSimulation/LevelTwo/SimLevelTwoTest_ISTVF_IG.mat p1 p2 p3

table(:,1) = p1;
table(:,2) = p2;
table(:,3) = p3;

clearvars p1 p2 p3

load ./06_results/TwoLevelSimulation/LevelTwo/SimLevelTwoTest_SIEM_IG.mat p1 p2 p3

table(:,4) = p1;
table(:,5) = p2;
table(:,6) = p3;