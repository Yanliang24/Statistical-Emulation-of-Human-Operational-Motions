clear
addpath('..\MotionCode\')
%% load data
% load RWP_1_Outcome_300.mat Ref_pos_data tree
% load SimSeqFull_1000_SIEM_Gaussian_NonParametric.mat
% load SimSeqFull_1000_ITVF_MultiGaussian_NonParametric.mat
% load .\Generation\Generation\Full\GenSeqFull_Motion5_Intrinsic.mat
% load .\Generation\Generation\Full\GenSeqFull_Motion1_SIEM_FPCA.mat
% load GenSeqFull_Motion1_LowDim_ITVF_FPCA.mat
% load mean_sequence.mat XM
for r = 1:5
    % load original
    original_file = sprintf("./Data/RWP_%d_Outcome_300.mat",r);
    temp = load(original_file);
    Ref_pos_data = temp.Ref_pos_data;
    tree = temp.tree;
    X = temp.aligned;

    XM = mean_posture_seq(X);
    [~, len1] = skeleton_to_posture(Ref_pos_data, tree);
    
    % load is-tvf simulation
    istvf_file = sprintf("./Result/Simulation/Subsequence/Full/GenSeqFull_Motion%d_ITVF_FPCA.mat", r);
    temp_istvf = load(istvf_file);
    X_new = temp_istvf.XnewG;
    Nv = 5;
    Iv1 = randperm(100,Nv);
    for i = 1:Nv
        XXv1 = X_new{Iv1(i)};
        % for j = 1:60
        %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
        % end
        % 
        % [~,ing] = min(ds1);
        XX0 = XM;
        filename = sprintf('ISTVF_Motion%d_%d',r,i);
        CreateVideo(XX0,XXv1,len1,tree,filename,8,5);
    end

    % load siem simulation
    siem_file = sprintf("./Result/Simulation/Subsequence/Full/GenSeqFull_Motion%d_SIEM_FPCA.mat", r);
    temp_siem = load(siem_file);
    X_new = temp_siem.XnewG;
    Nv = 5;
    Iv1 = randperm(100,Nv);
    for i = 1:Nv
        XXv1 = X_new{Iv1(i)};
        % for j = 1:60
        %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
        % end
        % 
        % [~,ing] = min(ds1);
        XX0 = XM;
        filename = sprintf('SIEM_Motion%d_%d',r,i);
        CreateVideo(XX0,XXv1,len1,tree,filename,8,5);
    end

    % load pwi simulation
    pwi_file = sprintf("./Result/Simulation/Subsequence/Full/GenSeqFull_Motion%d_Intrinsic.mat", r);
    temp_pwi = load(pwi_file);
    X_new = temp_pwi.X_new;
    Nv = 5;
    Iv1 = randperm(100,Nv);
    for i = 1:Nv
        XXv1 = X_new{Iv1(i)};
        % for j = 1:60
        %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
        % end
        % 
        % [~,ing] = min(ds1);
        XX0 = XM;
        filename = sprintf('PWI_Motion%d_%d',r,i);
        CreateVideo(XX0,XXv1,len1,tree,filename,8,5);
    end

end

for r = 1:5
    % load original
    original_file = sprintf("./Data/RWP_%d_Outcome_300.mat",r);
    temp = load(original_file);
    Ref_pos_data = temp.Ref_pos_data;
    tree = temp.tree;
    X = temp.aligned;

    XM = mean_posture_seq(X);
    [~, len1] = skeleton_to_posture(Ref_pos_data, tree);
    
    % load var simulation
    load SimSeqFull_100_VAR.mat Xnew
    X_new = Xnew(r,:);
    Nv = 2;
    Iv1 = randperm(100,Nv);
    for i = 1:Nv
        XXv1 = X_new{Iv1(i)};
        % for j = 1:60
        %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
        % end
        % 
        % [~,ing] = min(ds1);
        XX0 = XM;
        filename = sprintf('VAR_Motion%d_%d',r,i);
        CreateVideo(XX0,XXv1,len1,tree,filename,8,5);
    end

    % load gp simulation
    gp_file = sprintf("./Result/Simulation/Subsequence/Full/GenSeqFull_Motion%d_GP.mat", r);
    temp_gp = load(gp_file);
    X_new = temp_gp.Xnew;
    Nv = 2;
    Iv1 = randperm(60,Nv);
    for i = 1:Nv
        XXv1 = X_new{Iv1(i)};
        % for j = 1:60
        %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
        % end
        % 
        % [~,ing] = min(ds1);
        XX0 = XM;
        filename = sprintf('GP_Motion%d_%d',r,i);
        CreateVideo(XX0,XXv1,len1,tree,filename,8,5);
    end

    % load lstm simulation
    load SimSeq_60_LSTM.mat Xnew
    X_new = Xnew(r,1:60);
    Nv = 2;
    Iv1 = randperm(60,Nv);
    for i = 1:Nv
        XXv1 = X_new{Iv1(i)};
        % for j = 1:60
        %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
        % end
        % 
        % [~,ing] = min(ds1);
        XX0 = XM;
        filename = sprintf('LSTM_Motion%d_%d',r,i);
        CreateVideo(XX0,XXv1,len1,tree,filename,8,5);
    end
    
    % load gcn simulation
    load SimSeq_60_GCN_Trans.mat Xnew
    X_new = Xnew(r,1:60);
    Nv = 2;
    Iv1 = randperm(60,Nv);
    for i = 1:Nv
        XXv1 = X_new{Iv1(i)};
        % for j = 1:60
        %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
        % end
        % 
        % [~,ing] = min(ds1);
        XX0 = XM;
        filename = sprintf('GCN_Tran_Motion%d_%d',r,i);
        CreateVideo(XX0,XXv1,len1,tree,filename,8,5);
    end
end

% for i = 1:N
% XX = XG{r,Iseq1(i)};        
% skeleton_data_new = posture_to_skeleton(XX, len1, tree);
% figure(100+r*10+i)
% DrawSkeletonSequenceAction_SKKU(skeleton_data_new,30,'r','k', 1, 0, '', 0:300);
% set(gcf,'Position',[100 100 900 250])
% ax = gca;
% exportgraphics(ax,'.\paper\SIEM_Gaussian_Motion1.eps','Resolution',300) 
% end
% 
% Iseq2 = randperm(1000,N);
% for i = 1:N
% XX = XE{r,Iseq2(i)};        
% skeleton_data_new = posture_to_skeleton(XX, len1, tree);
% figure(200+r*10+i)
% DrawSkeletonSequenceAction_SKKU(skeleton_data_new,30,'r','k', 1, 0, '', 0:300);
% set(gcf,'Position',[100 100 900 250])
% ax = gca;
% exportgraphics(ax,'.\paper\SIEM_Gaussian_Motion1.eps','Resolution',300) 


%% Video
% Iv2 = randperm(100,Nv);
% for i = 1:Nv
%     XXv2 = XE{r,Iv2(i)};
%     for j = 1:60
%         ds2(j) = dist_seq_to_seq(Xt{j},XXv2);
%     end
% 
%     [~,ine] = min(ds2);
%     XX0 = Xt{ine};
%     filename = sprintf('ITVF_Nonparametric_(5x10)_Video_Motion%d_%d',r,i);
%     CreateVideo(XX0,XXv2,len1,tree,filename,8);
% end

% clear
%% New Data
load MotionNew_Outcome_800.mat X Ref_pos_data tree

% load SimSeqFull_New_100_ITVF.mat XGM
% XNew = XGM(:,1:99);
% 
% load SimSeqFull_New_100_SIEM.mat XGM
% XNew = XGM(:,1:99);
% 
% load SimSeqFull_New_100_PWI.mat Xnew
% XNew = Xnew(:,1:99);

[~, len1] = skeleton_to_posture(Ref_pos_data, tree);

XM = mean_posture_seq(X);
Nv = 10;
Iv1 = randperm(99,Nv);
for i = 1:Nv
    XXv1 = XNew{Iv1(i)};
    % for j = 1:60
    %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
    % end
    % 
    % [~,ing] = min(ds1);
    XX0 = XM;
    % filename = sprintf('PWI_ExerciseMotion_%d',i);
    filename = sprintf('PWI_ExerciseMotion_%d',i);
    CreateVideo_New(XX0,XXv1,len1,tree,filename,8,5);
end

% load var simulation
load SimSeqFull_New_100_VAR.mat Xnew
X_new = Xnew;
Nv = 2;
Iv1 = randperm(100,Nv);
for i = 1:Nv
    XXv1 = X_new{Iv1(i)};
    % for j = 1:60
    %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
    % end
    % 
    % [~,ing] = min(ds1);
    XX0 = XM;
    filename = sprintf('VAR_ExerciseMotion_%d',i);
    CreateVideo_New(XX0,XXv1,len1,tree,filename,8,5);
end

% load gp simulation
gp_file = sprintf("./Result/Simulation/Subsequence/Full/GenSeqFull_MotionNew_GP.mat");
temp_gp = load(gp_file);
X_new = temp_gp.Xnew;
Nv = 2;
Iv1 = randperm(60,Nv);
for i = 1:Nv
    XXv1 = X_new{Iv1(i)};
    % for j = 1:60
    %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
    % end
    % 
    % [~,ing] = min(ds1);
    XX0 = XM;
    filename = sprintf('GP_ExerciseMotion_%d',i);
    CreateVideo_New(XX0,XXv1,len1,tree,filename,8,5);
end

load GenSeqFull_New.mat XNew
% load lstm simulation
X_new = XNew(5,:);
Nv = 2;
Iv1 = randperm(99,Nv);
for i = 1:Nv
    XXv1 = X_new{Iv1(i)};
    % for j = 1:60
    %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
    % end
    % 
    % [~,ing] = min(ds1);
    XX0 = XM;
    filename = sprintf('LSTM_ExerciseMotion_%d',i);
    CreateVideo_New(XX0,XXv1,len1,tree,filename,8,5);
end

% load gcn simulation
X_new = XNew(6,:);
Nv = 2;
Iv1 = randperm(99,Nv);
for i = 1:Nv
    XXv1 = X_new{Iv1(i)};
    % for j = 1:60
    %     ds1(j) = dist_seq_to_seq(Xt{j},XXv1);
    % end
    % 
    % [~,ing] = min(ds1);
    XX0 = XM;
    filename = sprintf('GCN_Tran_ExerciseMotion_%d',i);
    CreateVideo_New(XX0,XXv1,len1,tree,filename,8,5);
end


