%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intermediate_Steps_Figure_S3_S4 - The code is to generate figure 3 and
% figure 4 in Supplementary Material
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
set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

load ../01_data/RWP_1_Outcome_300.mat

%% Figure 3 ISTVF
load ../06_results/WorkerData/ISTVF/run_1.mat
[Cre Zre] = PCAReconstruction(Sf,Uf,Mf,UdZ,MuZ);
[Xre,Yre,Cmre] = ISTVF_to_posture(Cre,V_ref,W_ref,mpos);

%% Function H
f3 = figure;
t3 = tiledlayout(1,3,"TileSpacing","compact");
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
nexttile;plot(squeeze(ZnewG(:,1,1:60)),'LineWidth',1.5);ylim([-8 8]);
hold on
plot(mean(squeeze(ZnewG(:,1,1:60)),2),'k','LineWidth',2)
title('Simulated $\mathbf{H}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f3,'ISTVF_Generation_H.pdf','Resolution',300) ;

%% Function G
f4 = figure;
t4 = tiledlayout(1,3,"TileSpacing","compact");
nexttile;plot(CIS(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(CIS(:,1:60,1),2),'k','LineWidth',2)
title('Original $\mathbf{G}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(squeeze(Cre(:,1:60,1)),'LineWidth',1.5);ylim([-0.6 0.4]);
title('Reconstructed $\tilde{\mathbf{G}}_{\alpha_m}$','Interpreter','latex')
hold on
plot(mean(squeeze(Cre(:,1:60,1)),2),'k','LineWidth',2)
set(gca,'FontSize', 14)
nexttile;plot(squeeze(CnewG(:,1:60,1)),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(CnewG(:,1:60,1)),2),'k','LineWidth',2)
title('Simulated $\mathbf{G}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f4,'ISHTVF_Generation_G.pdf','Resolution',300) ;

%% Function F
f5 = figure;
t5 = tiledlayout(1,3,"TileSpacing","compact");
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
nexttile;plot(CmNewG(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(CmNewG(:,1:60,1)),2),'k','LineWidth',2)
title('Simulated $\mathbf{F}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f5,'ISHTVF_Generation_F.pdf','Resolution',300) 

%% Sequence Example


%% Figure 4 SIEM
load ../06_results/WorkerData/SIEM/run_1.mat

[Cre Zre] = PCAReconstruction(Sf,Uf,Mf,UdZ,MuZ);

%% Fucntion H
f1 = figure;
t1 = tiledlayout(1,3,"TileSpacing","compact");
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
nexttile;plot(squeeze(ZnewG(:,1,1:60)),'LineWidth',1.5);ylim([-8 8]);
hold on
plot(mean(squeeze(ZnewG(:,1,1:60)),2),'k','LineWidth',2)
title('Simulated $\mathbf{H}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f1,'SIEM_Generation_H.pdf','Resolution',300) ;

%% Function W
f2 = figure;
t2 = tiledlayout(1,3,"TileSpacing","compact");
nexttile;plot(Cm(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(Cm(:,1:60,1)),2),'k','LineWidth',2)
title('Original $\mathbf{W}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(Cre(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(Cre(:,1:60,1)),2),'k','LineWidth',2)
title('Reconstructed $\tilde{\mathbf{W}}_{\alpha_m}$','Interpreter','latex')
set(gca,'FontSize', 14)
nexttile;plot(CnewG(:,1:60,1),'LineWidth',1.5);ylim([-0.6 0.4]);
hold on
plot(mean(squeeze(CnewG(:,1:60,1)),2),'k','LineWidth',2)
title('Simulated $\mathbf{W}_{\alpha_m}^*$','Interpreter','latex')
set(gca,'FontSize', 14)
set(gcf,'Position',[100 100 1200 200])
exportgraphics(f2,'SIEM_Generation_W.pdf','Resolution',300) 

%% Sequence Example

