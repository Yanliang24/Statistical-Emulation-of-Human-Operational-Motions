clear
addpath('..\MotionCode\')

load RWP_1_Outcome_300.mat Ref_pos_data tree
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);

%% SectionGeneration
I = randi(100,1,6);
%% ITVF
load .\Generation\Generation\Section_180_240\GenSeqSec_180_240_ITVF_FPCA.mat
X1 = XnewG{I(1)};  
skeleton_data_1 = posture_to_skeleton(X1, len1, tree);
X2 = XnewE{I(2)};
skeleton_data_2 = posture_to_skeleton(X2, len1, tree);
%% SIEM
load .\Generation\Generation\Section_180_240\GenSeqSec_180_240_SIEM_FPCA.mat
X3 = XnewG{I(3)};  
skeleton_data_3 = posture_to_skeleton(X3, len1, tree);
X4 = XnewE{I(4)};
skeleton_data_4 = posture_to_skeleton(X4, len1, tree);
%% Intrinsic
load .\Generation\Generation\Section_180_240\GenSeqSec_180_240_Intrinsic.mat
X5 = X_new{I(5)};  
skeleton_data_5 = posture_to_skeleton(X5, len1, tree);
%% VAR
load .\Generation\Generation\Section_180_240\GenSeqSec_180_240_ITVF_VAR.mat
X6 = X_New{I(6)};  
skeleton_data_6 = posture_to_skeleton(X6, len1, tree);


%% Posture Sequence Plot
f = figure;
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_1,6,'r','k',16, 1, -2, {'IS-TVF', '/Sequential-','PCA/MVG'}, 180:240);
% DrawSkeletonSequenceAction_SKKU_label(skeleton_data_2,6,'r','k', 1, -4, {'IS-TVF', 'Non-parametric'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_3,6,'r','k',16, 1, -4, {'SIEM', '/Sequential-','PCA/MVG'});
% DrawSkeletonSequenceAction_SKKU_label(skeleton_data_4,6,'r','k', 1, -8, {'SIEM', 'Non-parametric'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_5,6,'r','k',16, 1, -6, 'PWI');
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_6,6,'r','k',16, 1, -8, {'IS-TVF', '/Spatial-','PCA/VAR'});
set(gca, 'InnerPosition',[0.13 0.05 0.85 0.9])
set(gcf,'Position',[50 50 900 650])
% exportgraphics(f,'Section_generation_2.png','Resolution',300) 
% exportgraphics(f,'Section_generation_2.eps','Resolution',300) 
exportgraphics(f,'Section_generation_2.pdf','Resolution',300) 
%% ITVF Generation
I2 = randi(60);
load .\Generation\Generation\Full\GenSeqFull_Motion1_ITVF_FPCA.mat
XX1 = X{I2};  
skeleton_data_ISHTVF_1 = posture_to_skeleton(XX1, len1, tree);

for j = 1:100
    ds1(j) = dist_seq_to_seq(XnewG{j},XX1);
end
[~,ig] = min(ds1);
XX1G = XnewG{ig};
skeleton_data_ISHTVF_2 = posture_to_skeleton(XX1G, len1, tree);
for j = 1:100
    ds2(j) = dist_seq_to_seq(XnewE{j},XX1);
end
[~,ie] = min(ds2);
XX1E = XnewE{ie};
skeleton_data_ISHTVF_3 = posture_to_skeleton(XX1E, len1, tree);

f2 = figure;
DrawSkeletonSequenceAction_SKKU(skeleton_data_ISHTVF_1,30,'r','b', 1, -2, 'Original', 0:300);
DrawSkeletonSequenceAction_SKKU(skeleton_data_ISHTVF_2,30,'r','k', 1, -4, 'IS-TVF');
% DrawSkeletonSequenceAction_SKKU(skeleton_data_ISHTVF_3,30,'r','k', 1, -6, {'Non-','parametric'});
set(gcf,'Position',[100 100 900 350])
exportgraphics(f2,'ISHTVF_generation.png','Resolution',300) 
exportgraphics(f2,'ISHTVF_generation.eps','Resolution',300) 

%% SIEM Generation
I3 = randi(60);
load .\Generation\Generation\Full\GenSeqFull_Motion1_SIEM_FPCA.mat

XX2 = X{I3};  
skeleton_data_SIEM_1 = posture_to_skeleton(XX2, len1, tree);

for j = 1:100
    ds1(j) = dist_seq_to_seq(XnewG{j},XX2);
end
[~,ig] = min(ds1);
XX2G = XnewG{ig};
skeleton_data_SIEM_2 = posture_to_skeleton(XX2G, len1, tree);
for j = 1:100
    ds2(j) = dist_seq_to_seq(XnewE{j},XX2);
end
[~,ie] = min(ds2);
XX2E = XnewE{ie};
skeleton_data_SIEM_3 = posture_to_skeleton(XX2E, len1, tree);

f3 = figure;
DrawSkeletonSequenceAction_SKKU(skeleton_data_SIEM_1,30,'r','b', 1, -2, 'Original', 0:300);
DrawSkeletonSequenceAction_SKKU(skeleton_data_SIEM_2,30,'r','k', 1, -4, 'SIEM');
% DrawSkeletonSequenceAction_SKKU(skeleton_data_SIEM_3,30,'r','k', 1, -6, {'Non-','parametric'});
set(gcf,'Position',[100 100 900 350])
exportgraphics(f3,'SIEM_generation.png','Resolution',300) 
exportgraphics(f3,'SIEM_generation.eps','Resolution',300) 

%% Simulation
I4 = randi(100,3);
load .\Generation\Generation\Full\GenSeqFull_Motion1_ITVF_FPCA.mat
Y1 = XnewG{I4(1)};  
skeleton_data_sim_1 = posture_to_skeleton(Y1, len1, tree);

load .\Generation\Generation\Full\GenSeqFull_Motion1_SIEM_FPCA.mat
Y2 = XnewG{I4(2)};  
skeleton_data_sim_2 = posture_to_skeleton(Y2, len1, tree);

load .\Generation\Generation\Full\GenSeqFull_Intrinsic.mat
Y3 = X_new{I4(3)};  
skeleton_data_sim_3 = posture_to_skeleton(Y3, len1, tree);

f4 = figure;
DrawSkeletonSequenceAction_SKKU(skeleton_data_sim_1,30,'r','b', 1, -2, '(a)', 0:300);
DrawSkeletonSequenceAction_SKKU(skeleton_data_sim_2,30,'r','b', 1, -4, '(b)');
DrawSkeletonSequenceAction_SKKU(skeleton_data_sim_3,30,'r','b', 1, -6, '(c)');
set(gcf,'Position',[100 100 900 480])
exportgraphics(f4,'simulation.png','Resolution',300) 
exportgraphics(f4,'simulation.eps','Resolution',300) 

%% Simulation 2
I4 = randi(100,7);
load .\Generation\Simulation\LowDimSimulation\SimSeqFull_LowDimension_1000_ITVF_IndependentGaussian.mat
Y1 = XGI{1,I4(1)};  
skeleton_data_sim_1 = posture_to_skeleton(Y1, len1, tree);

load .\Generation\Simulation\LowDimSimulation\SimTest_LowDim_ITVF_Gaussian_1.mat
Y2 = XnewGI{1,I4(2)};  
skeleton_data_sim_2 = posture_to_skeleton(Y2, len1, tree);

Y3 = XnewGM{1,I4(3)};  
skeleton_data_sim_3 = posture_to_skeleton(Y3, len1, tree);

Y4 = XnewI{1,I4(3)};  
skeleton_data_sim_4 = posture_to_skeleton(Y4, len1, tree);

f4 = figure;
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_sim_1,30,'r','b', 16,1, -2, {'Training'}, 0:300);
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_sim_2,30,'r','k', 16,1, -4, {'IS-TVF','/Sequential-','PCA/IG'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_sim_3,30,'r','k', 16,1, -6, {'IS-TVF','/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_sim_4,30,'r','k', 16,1, -8, {'PWI'});
set(gca, 'InnerPosition',[0.13 0.05 0.85 0.9])
set(gcf,'Position',[50 50 900 650])
exportgraphics(f4,'ISTVF_Simulation.pdf','Resolution',300) 

I4 = randi(100,4);
load .\Generation\Simulation\LowDimSimulation\SimSeqFull_LowDimension_1000_SIEM_IndependentGaussian.mat
Y1 = XGI{1,I4(1)};  
skeleton_data_sim_1 = posture_to_skeleton(Y1, len1, tree);

load .\Generation\Simulation\LowDimSimulation\SimTest_LowDim_SIEM_Gaussian_1.mat
Y2 = XnewGI{1,I4(2)};  
skeleton_data_sim_2 = posture_to_skeleton(Y2, len1, tree);

Y3 = XnewGM{1,I4(3)};  
skeleton_data_sim_3 = posture_to_skeleton(Y3, len1, tree);

Y4 = XnewI{1,I4(4)};  
skeleton_data_sim_4 = posture_to_skeleton(Y4, len1, tree);

f4 = figure;
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_sim_1,30,'r','b',16, 1, -2, {'Training'}, 0:300);
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_sim_2,30,'r','k',16, 1, -4, {'SIEM','/Sequential-','PCA/IG'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_sim_3,30,'r','k',16, 1, -6, {'SIEM','/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_sim_4,30,'r','k',16, 1, -8, {'PWI'});
set(gca, 'InnerPosition',[0.13 0.05 0.85 0.9])
set(gcf,'Position',[50 50 900 650])
exportgraphics(f4,'SIEM_Simulation.pdf','Resolution',300) 

clear
addpath('..\MotionCode\')

load .\Data\RWP_1_Outcome_300.mat Ref_pos_data tree aligned
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
skeleton_data1 = posture_to_skeleton(aligned{1}, len1, tree);

load MotionNew_Outcome_800.mat Ref_pos_data tree X
[~, len2] = skeleton_to_posture(Ref_pos_data, tree);
skeleton_data2 = posture_to_skeleton_new(X{1}, len2, tree);
skeleton_data3 = skeleton_data2(:, :, [1, 3, 2])/1250;
skeleton_data3(:,end+1,:) = skeleton_data3(:,end,:);
skeleton_data3(:,:,[1 2]) = -skeleton_data3(:,:,[1 2]);
f5 = figure(10);
% skeleton_data3 = skeleton_data2/1250;
DrawSkeletonSequenceAction_SKKU_label(skeleton_data1,30,'r','b',16, 1, -2, {'Worker', 'Motion 1'}, 0:300);
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data3,80,'r','k',16, 1, -5, {'Exercise', 'Motion'}, 0:800);
% set(gca, 'InnerPosition',[0.13 0.05 0.85 0.9])
set(gcf,'Position',[50 50 900 310])
exportgraphics(f5,'Motion_Data_Example.pdf','Resolution',300) 