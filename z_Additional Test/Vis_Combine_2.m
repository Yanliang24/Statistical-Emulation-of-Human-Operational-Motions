clear

addpath ..\MotionCode\
% addpath ..\..\..\..\..\PartialElastic\Code\ModeEst_DistMat\
% addpath ..\..\..\..\PartialElastic\Code\NewMultpleAlignmentCode\
addpath ..\..\..\..\Project_new\Code_accelaration\
addpath ..\..\..\..\Project_new\Code_accelaration\Code_Short_Test\

%% load data
load ..\Data\RWP_1_Outcome_300.mat Ref_pos_data tree aligned
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);

I = randi(60,1,8);
X(1) = aligned(1,I(1));
% Simulation
load GenSeqFull_100_ITVF_FPCA.mat Xnew
X(2) = Xnew(1,I(2));

load GenSeqFull_100_SIEM_FPCA.mat Xnew
X(3) = Xnew(1,I(3));

load GenSeqFull_100_PWI.mat Xnew
X(4) = Xnew(1,I(4));

load SimSeqFull_100_VAR.mat Xnew
X(5) = Xnew(1,I(5));
        
load SimSeq_60_LSTM.mat Xnew
X(6) = Xnew(1,I(6));

load SimSeq_60_GCN_Trans.mat Xnew
X(7) = Xnew(1,I(7));

load ..\GenSeqFull_100_GP.mat X_new
X(8) = X_new(1,I(8));
%% ITVF
for i = 1:8
    skeleton_data{i} = posture_to_skeleton(X{i}(:,101:110,:), len1, tree);
end

%% Posture Sequence Plot
f1 = figure;
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{1},1,'r','b',16, 1, -2, {'Original'}, 101:110);
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{2},1,'r','k',16, 1, -4, {'IS-TVF', '/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{3},1,'r','k',16, 1, -6, {'SIEM', '/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{4},1,'r','k',16, 1, -8, 'PWI');
set(gca, 'InnerPosition',[0.10 0.05 0.9 0.88])
set(gcf,'Position',[50 50 800 540])
exportgraphics(f1,'Simulation_compare_motion1_1_short.pdf','Resolution',300) 

f2 = figure;
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{5},30,'r','k',16, 1, -2, {'IS-TVF', '/Spatial-','PCA/VAR'}, 0:300);
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{8},30,'r','k',16, 1, -4, {'SIEM', '/Spatial-','PCA/GP'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{6},30,'r','k',16, 1, -6, {'LSTM'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{7},30,'r','k',16, 1, -8, {'GCN-', 'Transformer'});
set(gca, 'InnerPosition',[0.10 0.05 0.9 0.88])
set(gcf,'Position',[50 50 800 540])
% exportgraphics(f,'Section_generation_2.png','Resolution',300) 
% exportgraphics(f,'Section_generation_2.eps','Resolution',300) 
exportgraphics(f2,'Simulation_compare_3_2.pdf','Resolution',300) 

DrawSkeletonSequenceAction_SKKU_label(skeleton_data{4},30,'r','k',16, 1, -8, {'IS-TVF', '/Spatial-','PCA/VAR'});

% f3 = figure('Visible', 'off');
f3 = figure;
% set(f3, 'Units', 'inches');
% % set(f3, 'Position', [0 0 5.4 8.1]); % Set screen pos (just in case)
% set(f3, 'PaperUnits', 'inches');
% set(f3, 'PaperPosition', [0 0 5.4 8.1]); % The size of the content
% set(f3, 'PaperSize', [5.4 8.1]);         % The size of the PDF page
% set(f3, 'PaperPositionMode', 'manual');             % CRITICAL: Disconnect from screen
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{1},1,'r','b',10, 1, -2, {'Original'}, (101:110));
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{2},1,'r','k',10, 1, -4, {'IS-TVF', '/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{3},1,'r','k',10, 1, -6, {'SIEM', '/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{4},1,'r','k',10, 1, -8, 'PWI');
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{5},1,'r','k',10, 1, -10, {'IS-TVF', '/Spatial-','PCA/VAR'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{8},1,'r','k',10, 1, -12, {'SIEM', '/Spatial-','PCA/GP'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{6},1,'r','k',10, 1, -14, {'LSTM'});
DrawSkeletonSequenceAction_SKKU_label(skeleton_data{7},1,'r','k',10, 1, -16, {'GCN-', 'Transformer'});
set(gca, 'InnerPosition',[0.10 0.05 0.9 0.88])
set(gcf,'Position',[10 10 600 900])
% exportgraphics(f,'Section_generation_2.png','Resolution',300) 
% exportgraphics(f,'Section_generation_2.eps','Resolution',300) 
% exportgraphics(f3,'Simulation_compare_motion1.pdf','ContentType','vector') 
exportgraphics(f3,'Simulation_compare_motion2_1.pdf','Resolution',300) 

load ..\MotionNew_Outcome_800.mat Ref_pos_data tree X 
Xnew0 = X;
clear X

% Simulation
load GenSeqFull_New.mat XNew

I = randi(60,1,8);
X(1) = Xnew0(1,I(1));
% Simulation
% ISTVF
X(2) = XNew(1,I(2));
%SIEM
X(3) = XNew(2,I(3));
%PWI
X(4) = XNew(3,I(4));
%VAR
X(5) = XNew(4,I(5));
%LSTM        
X(6) = XNew(5,I(6));
%GCN+Tra
X(7) = XNew(6,I(7));
%GP
load ..\Result\Simulation\Subsequence\Full\GenSeqFull_MotionNew_GP.mat
X(8) = Xnew(I(8));

[~, len2] = skeleton_to_posture(Ref_pos_data, tree);

for i = 1:8
    skeleton_data_t = posture_to_skeleton_new(X{i}(:,101:110,:), len2, tree);
    skeleton_data_t = skeleton_data_t(:, :, [1, 3, 2])/1250;
    % skeleton_data_t(:,end+1,:) = skeleton_data_t(:,end,:);
    skeleton_data_t(:,:,[1 2]) = -skeleton_data_t(:,:,[1 2]);
    skeleton_data{i} = skeleton_data_t;
end

f4 = figure;
% set(f3, 'Units', 'inches');
% % set(f3, 'Position', [0 0 5.4 8.1]); % Set screen pos (just in case)
% set(f3, 'PaperUnits', 'inches');
% set(f3, 'PaperPosition', [0 0 5.4 8.1]); % The size of the content
% set(f3, 'PaperSize', [5.4 8.1]);         % The size of the PDF page
% set(f3, 'PaperPositionMode', 'manual');             % CRITICAL: Disconnect from screen
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data{1},1,'r','b',10, 1, -2, {'Original'}, (101:110));
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data{2},1,'r','k',10, 1, -4, {'IS-TVF', '/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data{3},1,'r','k',10, 1, -6, {'SIEM', '/Sequential-','PCA/MVG'});
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data{4},1,'r','k',10, 1, -8, 'PWI');
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data{5},1,'r','k',10, 1, -10, {'IS-TVF', '/Spatial-','PCA/VAR'});
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data{8},1,'r','k',10, 1, -12, {'SIEM', '/Spatial-','PCA/GP'});
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data{6},1,'r','k',10, 1, -14, {'LSTM'});
DrawSkeletonSequenceAction_SKKU_label_new(skeleton_data{7},1,'r','k',10, 1, -16, {'GCN-', 'Transformer'});
set(gca, 'InnerPosition',[0.10 0.05 0.9 0.88])
set(gcf,'Position',[10 10 650 900])
% exportgraphics(f,'Section_generation_2.png','Resolution',300) 
% exportgraphics(f,'Section_generation_2.eps','Resolution',300) 
% exportgraphics(f3,'Simulation_compare_motion1.pdf','ContentType','vector') 
exportgraphics(f4,'Simulation_compare_motionNew_1.pdf','Resolution',300) 


CreateSingleVideo(aligned{1},len1,tree,'Worker_Video_Original',8)