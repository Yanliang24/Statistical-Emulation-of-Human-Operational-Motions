%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Intermediate_Steps_Figure_S4_S5 - The code is to generate figure 4 and
% figure 5 in Supplementary Material
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear
addpath('../02_functions/')
set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

load ../01_data/RWP_1_Outcome_300.mat aligned Ref_pos_data tree             % Use the first dataset as an example

%% Figure 4 ISTVF
load ../06_results/WorkerData/ISTVF/run_1.mat Result                        % load first run as an example                                                    % use the first dataset as an example
X0 = aligned;

[CIS,V_ref,W_ref,mpos,Xc,Yc,Cm] = FormISTVF(X0);
[Ty, M, D] = size(CIS);
D1 = 10; D2 = 30;

% PCA reconstructed sequences
[ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,D1);
[Uf,Vf,Mf,S,ef,ex,SigK] = FullfPCA(ZZ,D2);

[CIre, Zre] = PCAReconstruction(S,Uf,Mf,UdZ,MuZ);
[Xre,Yre,Cmre] = ISTVF_to_posture(CIre,V_ref,W_ref,mpos);

%Simulated sequences
X1 = Result.SimulatedData(1,:);
[CInew,~,~,~,~,~,Cmnew] = FormISTVF(X1, mpos);

CInew_flatten = reshape(CInew, [], D);
Znew = (CInew_flatten-Result.params.class_1.SPCAmean)*Result.params.class_1.SPCcom;
Znew = reshape(Znew, Ty, [], D1);

%% Function H
f1 = figure;
t1 = tiledlayout(1,3,"TileSpacing","compact");
nexttile;plot(ZZ(:,1:60,1),'LineWidth',1.5);ylim([-8 8]);
hold on
plot(mean(ZZ(:,1:60,1),2),'k','LineWidth',2)
title('Original $\mathbf{H}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(squeeze(Zre(:,1,1:60)),'LineWidth',1.5);ylim([-8 8]);
title('Reconstructed $\tilde{\mathbf{H}}_{\alpha_m}$','Interpreter','latex')
hold on
plot(mean(squeeze(Zre(:,1,1:60)),2),'k','LineWidth',2)
set(gca,'FontSize', 14)
nexttile;plot(squeeze(Znew(:,1:60,1)),'LineWidth',1.5);ylim([-8 8]);
hold on
plot(mean(squeeze(Znew(:,1:60,1)),2),'k','LineWidth',2)
title('Simulated $\mathbf{H}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f1,'../06_results/figures/ISTVF_Generation_H.pdf','Resolution',300);

%% Function G
f2 = figure;
t2 = tiledlayout(1,3,"TileSpacing","compact");
nexttile;plot(CIS(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(CIS(:,1:60,1),2),'k','LineWidth',2)
title('Original $\mathbf{G}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(squeeze(CIre(:,1:60,1)),'LineWidth',1.5);ylim([-0.6 0.4]);
title('Reconstructed $\tilde{\mathbf{G}}_{\alpha_m}$','Interpreter','latex')
hold on
plot(mean(squeeze(CIre(:,1:60,1)),2),'k','LineWidth',2)
set(gca,'FontSize', 14)
nexttile;plot(squeeze(CInew(:,1:60,1)),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(CInew(:,1:60,1)),2),'k','LineWidth',2)
title('Simulated $\mathbf{G}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f2,'../06_results/figures/ISHTVF_Generation_G.pdf','Resolution',300);

%% Function F
f3 = figure;
t3 = tiledlayout(1,3,"TileSpacing","compact");
nexttile;plot(Cm(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(Cm(:,1:60,1)),2),'k','LineWidth',2)
title('Original $\mathbf{F}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(Cmre(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(Cmre(:,1:60,1)),2),'k','LineWidth',2)
title('Reconstructed $\tilde{\mathbf{F}}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(Cmnew(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(Cmnew(:,1:60,1)),2),'k','LineWidth',2)
title('Simulated $\mathbf{F}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f3,'../06_results/figures/ISHTVF_Generation_F.pdf','Resolution',300); 

%% Sequence Example
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
x0 = X0{1};  
skeleton_data_ISTVF_0 = posture_to_skeleton(x0, len1, tree);

x1 = X1{1};
skeleton_data_ISTVF_1 = posture_to_skeleton(x1, len1, tree);

f4 = figure;
DrawSkeletonSequenceAction(skeleton_data_ISTVF_0,30,'r','b',16, 1, -2, 'Original', 0:300);
DrawSkeletonSequenceAction(skeleton_data_ISTVF_1,30,'r','k',16, 1, -4, 'IS-TVF');
set(gcf,'Position',[100 100 900 350])
exportgraphics(f4,'../06_results/figures/ISTVF_generation.pdf','Resolution',300) 

%% Figure 5 SIEM
clearvars -except aligned Ref_pos_data tree
load ../06_results/WorkerData/SIEM/run_1.mat Result
X0 = aligned;

[Cm,V_ref,W_ref,mpos] = FormSIEM(X0);
[Ty, M, D] = size(Cm);
D1 = 10; D2 = 30;

% PCA reconstructed sequences
[ZZ,MuZ,UdZ,SigZ] = SpatialPCA(Cm,D1);
[Uf,Vf,Mf,S,ef,ex,SigK] = FullfPCA(ZZ,D2);

[Cmre, Zre] = PCAReconstruction(S,Uf,Mf,UdZ,MuZ);
[Xre] = SIEM_to_posture(Cmre,V_ref,W_ref,mpos);

%Simulated sequences
X1 = Result.SimulatedData(1,:);
[Cmnew] = FormSIEM(X1, mpos);

Cmnew_flatten = reshape(Cmnew, [], D);
Znew = (Cmnew_flatten-Result.params.class_1.SPCAmean)*Result.params.class_1.SPCcom;
Znew = reshape(Znew, Ty, [], D1);


%% Fucntion H
f5 = figure;
t5 = tiledlayout(1,3,"TileSpacing","compact");
nexttile;plot(ZZ(:,1:60,1),'LineWidth',1.5);ylim([-8 8]);
hold on
plot(mean(ZZ(:,1:60,1),2),'k','LineWidth',2)
title('Original $\mathbf{H}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(squeeze(Zre(:,1,1:60)),'LineWidth',1.5);ylim([-8 8]);
hold on
plot(mean(squeeze(Zre(:,1,1:60)),2),'k','LineWidth',2)
title('Reconstructed $\tilde{\mathbf{H}}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(squeeze(Znew(:,1:60,1)),'LineWidth',1.5);ylim([-8 8]);
hold on
plot(mean(squeeze(Znew(:,1:60,1)),2),'k','LineWidth',2)
title('Simulated $\mathbf{H}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f5,'../06_results/figures/SIEM_Generation_H.pdf','Resolution',300) ;

%% Function W
f6 = figure;
t6 = tiledlayout(1,3,"TileSpacing","compact");
nexttile;plot(Cm(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(Cm(:,1:60,1)),2),'k','LineWidth',2)
title('Original $\mathbf{W}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(Cmre(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(Cmre(:,1:60,1)),2),'k','LineWidth',2)
title('Reconstructed $\tilde{\mathbf{W}}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(Cmnew(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(Cmnew(:,1:60,1)),2),'k','LineWidth',2)
title('Simulated $\mathbf{W}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f6,'../06_results/figures/SIEM_Generation_W.pdf','Resolution',300) 

%% Sequence Example
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
x0 = X0{1};  
skeleton_data_SIEM_0 = posture_to_skeleton(x0, len1, tree);

x1 = X1{1};
skeleton_data_SIEM_1 = posture_to_skeleton(x1, len1, tree);

f7 = figure;
DrawSkeletonSequenceAction(skeleton_data_SIEM_0,30,'r','b',16, 1, -2, 'Original', 0:300);
DrawSkeletonSequenceAction(skeleton_data_SIEM_1,30,'r','k',16, 1, -4, 'SIEM');
set(gcf,'Position',[100 100 900 350])
exportgraphics(f7,'../06_results/figures/SIEM_generation.pdf','Resolution',300) 