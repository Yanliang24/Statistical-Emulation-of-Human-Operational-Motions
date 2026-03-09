%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Flattening_Compare_Figure4_5 - The code is to generate figure 4 and
% figure 5
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear

addpath('../02_functions/')

%% Figure 2
load ..\01_data\RWP_1_Outcome_300.mat Ref_pos_data tree aligned
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
skeleton_data1 = posture_to_skeleton(aligned{1}, len1, tree);

load ..\01_data\MotionNew_Outcome_800.mat Ref_pos_data tree X
[~, len2] = skeleton_to_posture(Ref_pos_data, tree);

skeleton_data2 = posture_to_skeleton_new(X{1}, len2, tree);
skeleton_data3 = skeleton_data2(:, :, [1, 3, 2])/1250;
skeleton_data3(:,end+1,:) = skeleton_data3(:,end,:);
skeleton_data3(:,:,[1 2]) = -skeleton_data3(:,:,[1 2]);
f1 = figure;
DrawSkeletonSequenceAction_label(skeleton_data1,30,'r','b',16, 1, -2, {'Worker', 'Motion 1'}, 0:300);
DrawSkeletonSequenceAction_label_new(skeleton_data3,80,'r','k',16, 1, -5, {'Exercise', 'Motion'}, 0:800);
set(gcf,'Position',[50 50 900 310])
exportgraphics(f1,'../06_results/figures/Motion_Data_Example.pdf','Resolution',300) 

%% Figure 11
%% load data
load ..\01_data\RWP_1_Outcome_300.mat Ref_pos_data tree aligned
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
%% Original Sequence
I = randi(60,1,8);
X(1) = aligned(1,I(1));

%% Simulated Sequences
% ISTVF
load ../06_results/WorkerData/ISTVF/run_1.mat Result
X{2} = Result.SimulatedData{1,1};

% SIEM
load ../06_results/WorkerData/SIEM/run_1.mat Result
X{3} = Result.SimulatedData{1,1};

% PWI
load ../06_results/WorkerData/PWI/run_1.mat Result
X{4} = Result.SimulatedData{1,1};

% VAR
load ../06_results/WorkerData/VAR/run_1.mat Result
X{5} = Result.SimulatedData{1,1};

% GP
load ../06_results/WorkerData/Other/GP_Worker_Results.mat All_Results
X{6} = All_Results.Dataset1.simulated{1,1};

% LSTM
load ../06_results/WorkerData/Other/LSTM_Worker_Results.mat All_Results
X{7} = All_Results.Dataset1.simulated{1,1};

% GCN_Transformer
load ../06_results/WorkerData/Other/GCN_Trans_Worker_Results.mat All_Results
X{8} = All_Results.Dataset1.simulated{1,1};

for i = 1:8
    skeleton_data{i} = posture_to_skeleton(X{i}, len1, tree);
end

%% Posture Sequence Plot
f2 = figure;
DrawSkeletonSequenceAction_label(skeleton_data{1},30,'r','b',16, 1, -2, {'Original'}, 0:300);
DrawSkeletonSequenceAction_label(skeleton_data{2},30,'r','k',16, 1, -4, {'IS-TVF', '/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_label(skeleton_data{3},30,'r','k',16, 1, -6, {'SIEM', '/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_label(skeleton_data{4},30,'r','k',16, 1, -8, 'PWI');
set(gca, 'InnerPosition',[0.10 0.05 0.9 0.88])
set(gcf,'Position',[50 50 800 540])
exportgraphics(f2,'../06_results/figures/Simulation_compare_3_1.pdf','Resolution',300) 

f3 = figure;
DrawSkeletonSequenceAction_label(skeleton_data{5},30,'r','k',16, 1, -2, {'IS-TVF', '/Spatial-','PCA/VAR'}, 0:300);
DrawSkeletonSequenceAction_label(skeleton_data{8},30,'r','k',16, 1, -4, {'SIEM', '/Spatial-','PCA/GP'});
DrawSkeletonSequenceAction_label(skeleton_data{6},30,'r','k',16, 1, -6, {'LSTM'});
DrawSkeletonSequenceAction_label(skeleton_data{7},30,'r','k',16, 1, -8, {'GCN-', 'Transformer'});
set(gca, 'InnerPosition',[0.10 0.05 0.9 0.88])
set(gcf,'Position',[50 50 800 540])
exportgraphics(f3,'../06_results/figures/Simulation_compare_3_2.pdf','Resolution',300) 

%% Figure 12

%% ISTVF/IG
load ../06_results/TwoLevelSimulation/LevelTwo/SimLevelTwoTest_ISTVF_IG.mat Xtrain XnewIG XnewMG XnewI
XX1{1} = Xtrain{1};
XX1{2} = XnewIG{1};
XX1{3} = XnewMG{1};
XX1{4} = XnewI{1};

for i = 1:4
    skeleton_data_sim_istvf{i} = posture_to_skeleton(XX1{i}, len1, tree);
end

f4 = figure;
DrawSkeletonSequenceAction_label(skeleton_data_sim_istvf{1},30,'r','b', 16,1, -2, {'Training'}, 0:300);
DrawSkeletonSequenceAction_label(skeleton_data_sim_istvf{2},30,'r','k', 16,1, -4, {'IS-TVF','/Sequential-','PCA/IG'});
DrawSkeletonSequenceAction_label(skeleton_data_sim_istvf{3},30,'r','k', 16,1, -6, {'IS-TVF','/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_label(skeleton_data_sim_istvf{4},30,'r','k', 16,1, -8, {'PWI'});
set(gca, 'InnerPosition',[0.13 0.05 0.85 0.9])
set(gcf,'Position',[50 50 900 650])
exportgraphics(f4,'../06_results/figures/ISTVF_Simulation.pdf','Resolution',300) 

%% SIEM/IG
load ../06_results/TwoLevelSimulation/LevelTwo/SimLevelTwoTest_SIEM_IG.mat Xtrain XnewIG XnewMG XnewI
XX2{1} = Xtrain{1};
XX2{2} = XnewIG{1};
XX2{3} = XnewMG{1};
XX2{4} = XnewI{1};

for i = 1:4
    skeleton_data_sim_siem{i} = posture_to_skeleton(XX2{i}, len1, tree);
end

f5 = figure;
DrawSkeletonSequenceAction_label(skeleton_data_sim_siem{1},30,'r','b',16, 1, -2, {'Training'}, 0:300);
DrawSkeletonSequenceAction_label(skeleton_data_sim_siem{2},30,'r','k',16, 1, -4, {'SIEM','/Sequential-','PCA/IG'});
DrawSkeletonSequenceAction_label(skeleton_data_sim_siem{3},30,'r','k',16, 1, -6, {'SIEM','/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_label(skeleton_data_sim_siem{4},30,'r','k',16, 1, -8, {'PWI'});
set(gca, 'InnerPosition',[0.13 0.05 0.85 0.9])
set(gcf,'Position',[50 50 900 650])
exportgraphics(f5,'../06_results/figures/SIEM_Simulation.pdf','Resolution',300) 