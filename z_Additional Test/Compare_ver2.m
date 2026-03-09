clear

addpath ..\MotionCode\
% addpath ..\..\..\..\..\PartialElastic\Code\ModeEst_DistMat\
% addpath ..\..\..\..\PartialElastic\Code\NewMultpleAlignmentCode\
addpath ..\..\..\..\Project_new\Code_accelaration\
addpath ..\..\..\..\Project_new\Code_accelaration\Code_Short_Test\
addpath ..\


%% load data
% Original 
load ..\Data\RWP_all_Outcome_300.mat X
for r = 1:5
    idx = [1+60*(r-1):60*r];    
    X0(r,:) = X(idx);  
end

clear X

% Simulation
load GenSeqFull_100_ITVF_FPCA.mat Xnew
for i = 1:5
    X(:,1,i) = Xnew(i,1:60);
end

load GenSeqFull_100_SIEM_FPCA.mat Xnew
for i = 1:5
    X(:,2,i) = Xnew(i,1:60);
end

load GenSeqFull_100_PWI.mat Xnew
for i = 1:5
    X(:,3,i) = Xnew(i,1:60);
end

load SimSeqFull_100_VAR.mat Xnew
for i = 1:5
    X(:,4,i) = Xnew(i,1:60);
end

load SimSeq_60_LSTM.mat Xnew
for i = 1:5
    X(:,5,i) = Xnew(i,1:60);
end


load SimSeq_60_GCN_Trans.mat Xnew
for i = 1:5
    X(:,6,i) = Xnew(i,1:60);
end

%% Energy Distance
for i = 1:6
    for j = 1:5
        D(i,j) = EnergyDistance(X0(j,:), X(:,i,j)');
    end
end

%% KNN
for i = 1:6
    for j = 1:5
        a(i,j) = KNN_test_all(X0(j,:), X(:,i,j)', 5);
    end
end


%% Nearest Neighbor Distance 
for i = 1:6
    for j = 1:5
        annd(i,j) = ANND(X0(j,:), X(:,i,j)');
    end
end


%% Mean of Max Distance 
for i = 1:6
    for j = 1:5
        mmd(i,j) = MMD(X0(j,:), X(:,i,j)');
    end
end

%% ANND of Max Posture Distance
for i = 1:6
    for j = 1:5
        mpd(i,j) = ANND_MP(X0(j,:), X(:,i,j)');
    end
end

%% Roughness
for i = 1:6
    for j = 1:5
        R(i,j) = ANND_R(X0(1,:), X(:,i,j)');
    end
end

%% Quantization Varibility
load posture_modes_12.mat

for i = 1:5
    XM{i} = mean_posture_seq(X0(i,:));
    Q0(i) = quan_var(X0(i,:), posturemode, XM{i});
end

for i = 1:6
    for j = 1:5
        Q(i,j) = quan_var(X(:,i,j)', posturemode, XM{j});
    end
end

%% Posture Validity
load Estimated_ROW.mat 
load ..\Data\RWP_1_Outcome_300.mat tree

for j = 1:5
    [S0(j), I0(j)] = Validity_Test(X0(j,:), KernelVMF, 0.05, tree);
end

for i = 1:6
    for j = 1:5
        [S(i,j), IR(i,j)] = Validity_Test(X(:,i,j), KernelVMF, 0.05, tree);
    end
end

%% Jerk Test
for j = 1:5
    J0(j) = Jerk_test(X0(j,:));
end

for i = 1:6
    for j = 1:5
        J(i,j) = Jerk_test(X(:,i,j));
    end
end

%% Acceleration Test
for j = 1:5
    A0(j) = Acc_test(X0(j,:));
end

for i = 1:6
    for j = 1:5
        A(i,j) = Acc_test(X(:,i,j));
    end
end

%% Cross_sectional variance
for j = 1:5
    CV0(j) = cross_sectional_variance(X0(j,:));
end

for i = 1:6
    for j = 1:5
        CV(i,j) = cross_sectional_variance(X(:,i,j)');
    end
end

%% New Motion
load ..\MotionNew_Outcome_800.mat X 
Xnew0 = X;
clear X

% Simulation
load GenSeqFull_New.mat XNew

%% Energy Distance
for i = 1:6
    Dnew(i) = EnergyDistance(Xnew0, XNew(i,:));
end

%% KNN
for i = 1:6
    a_new(i) = KNN_test_all(Xnew0, XNew(i,:), 5);
end


%% Nearest Neighbor Distance 
for i = 1:6
    annd_new(i) = ANND(Xnew0, XNew(i,:));
end


%% Mean of Max Distance 
for i = 1:6
    mmd_new(i) = MMD(Xnew0, XNew(i,:));
end

%% ANND of Max Posture Distance
for i = 1:6
    mpd_new(i) = ANND_MP(Xnew0, XNew(i,:));
end

%% Roughness
for i = 1:6
    R_new(i) = ANND_R(Xnew0, XNew(i,:));
end

%% Quantization Varibility
load posture_modes_new_ver1.mat

X_newM = mean_posture_seq(Xnew0);
Q_new0 = quan_var(Xnew0, cluster, X_newM);

for i = 1:6
    Q_new(i) = quan_var(XNew(i,:), cluster, X_newM);
end

%% Posture Validity
load Estimated_ROW_New.mat 
load ..\MotionNew_Outcome_800.mat tree
S_new0 = Validity_Test(Xnew0, KernelVMF, 0.05, tree);


for i = 1:6
    [S_new(i), IR_new(i)] = Validity_Test(XNew(i,:), KernelVMF, 0.05, tree);
end

%% Jerk Test
J_new0 = Jerk_test(Xnew0);

for i = 1:6
    J_new(i) = Jerk_test(XNew(i,:));
end

%% Acc Test
A_new0 = Acc_test(Xnew0);

for i = 1:6
    A_new(i) = Acc_test(XNew(i,:));
end


CV_new0 = cross_sectional_variance(Xnew0);


for i = 1:6
    CV_new(i) = cross_sectional_variance(XNew(i,:));
end


clear
load ..\MotionNew_Outcome_800.mat
load GenSeqFull_New.mat XNew

CreateVideo_New(X{1}, XNew{2,1},len1,tree, 'Motion_New_SIEM', 8, 75)


%% Create Video
load ..\Data\RWP_all_Outcome_300.mat Ref_pos_data tree
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);

%ISTVF
I = randperm(60,5);
for i = 1:5
    filenames = strcat('Video_Motion_1_',num2str(i),'_ISTVF');
    CreateVideo(X0{1,I(i)},X{I(i),1,1}, len1, tree, filenames, 8, 50)
end

%SIEM
I = randperm(60,5);
for i = 1:5
    filenames = strcat('Video_Motion_1_',num2str(i),'_SIEM');
    CreateVideo(X0{1,I(i)},X{I(i),2,1}, len1, tree, filenames, 8, 50)
end

