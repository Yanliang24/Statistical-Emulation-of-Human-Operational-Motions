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
load ../01_data/RWP_1_Outcome_300.mat

set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

%% Figure 4
[CIS,V_ref,W_ref,mpos,Xc,Yc,Cm] = FormISTVF(aligned);

figure
yyaxis left
plot(Cm(:,8,2),'linewidth',2)
ylabel('S-TVF value')
hold on
yyaxis right
plot(CIS(:,8,2),'linewidth',2)
ylabel('IS-TVF value')
ylim([-0.4 0.4])
xlabel('Time $t$','Interpreter','latex')
legend('S-TVF','IS-TVF')
set(gca,'FontSize',14);
set(gcf,'Position',[100 100 560 250])
ax = gca;
exportgraphics(ax,'../06_results/figures/ITVF1.pdf','Resolution',300) 

figure
yyaxis left
plot(Cm(:,7,2),'linewidth',2)
ylabel('S-TVF value')
ylim([-0.31 0.31])
hold on
yyaxis right
plot(CIS(:,7,2),'linewidth',2)
ylabel('IS-TVF value')
ylim([-0.61 0.61])
xlabel('Time $t$','Interpreter','latex')
legend('S-TVF','IS-TVF')
set(gca,'FontSize',14)
set(gcf,'Position',[100 100 560 250])
ax = gca;
exportgraphics(ax,'../06_results/figures/ITVF2.pdf','Resolution',300) 

%% Figure 5
rng(123456)
I = randi(60);
X = aligned{I};
Ty = size(X,2);
X0 = squeeze(X(:,1,:));

%% STVF
Y_STVF = STVF(X);
X_STVF = STVF_Recon(Y_STVF,X0);

%% MTVF
Y_MTVF = MTVF(X);
X_MTVF = MTVF_Recon(Y_MTVF,X0);

%% SIEM
Y_SIEM = TangentF(X,X0);
X_SIEM = TangentF_Recon(Y_SIEM,X0);

%% Plot
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
skeleton_data = posture_to_skeleton(X, len1, tree);

f1=figure(1);
DrawSkeletonSequenceActionLarge(skeleton_data,30,'r','k',16, 1, -2*1, 'Original',0:300);

skeleton_data_1 = posture_to_skeleton(X_STVF, len1, tree);
DrawSkeletonSequenceActionLarge(skeleton_data,30,'r','k',16, 1, -2*2, {'S-TVF','(IS-TVF)'});
hold on
DrawSkeletonSequenceAction(skeleton_data_1,30,'y','b',16, 1, -2*2);

skeleton_data_2 = posture_to_skeleton(X_MTVF, len1, tree);
DrawSkeletonSequenceActionLarge(skeleton_data,30,'r','k',16, 1, -2*3, 'M-TVF');
hold on
DrawSkeletonSequenceAction(skeleton_data_2,30,'y','b',16, 1, -2*3) 

skeleton_data_3 = posture_to_skeleton(X_SIEM, len1, tree);
DrawSkeletonSequenceActionLarge(skeleton_data,30,'r','k',16, 1, -2*4, 'SIEM');
hold on
DrawSkeletonSequenceAction(skeleton_data_3,30,'y','b',16, 1, -2*4);
set(gcf,'Position',[100 100 900 600])

exportgraphics(f1,'../06_results/figures/flattening_compare_1.pdf','Resolution',300)

for i = 1:60
    X = aligned{i};
    X0 = squeeze(X(:,1,:));
    %% STVF
    Y_STVF = STVF(X);
    X_STVF = STVF_Recon(Y_STVF,X0);
    
    %% TVF    
    Y_MTVF = MTVF(X);
    X_MTVF = MTVF_Recon(Y_MTVF,X0);
    
    %% SIEM    
    Y_SIEM = TangentF(X,X0);
    X_SIEM = TangentF_Recon(Y_SIEM,X0);
    
    %% Compute reconstruction error
    for t = 1:Ty
        d1(i,t) = dist_seq_to_seq(X(:,t,:),X_STVF(:,t,:));
        d2(i,t) = dist_seq_to_seq(X(:,t,:),X_MTVF(:,t,:));
        d3(i,t) = dist_seq_to_seq(X(:,t,:),X_SIEM(:,t,:));
    end
end

f2 = figure;
t = tiledlayout(2,1,"TileSpacing","tight","Padding","tight");
nexttile(1);
plot(mean(d1),'LineWidth',2)
hold on
plot(mean(d3),'LineWidth',2)
xlim([0 301])
set(gca,'FontSize',16)
legend('S-TVF','SIEM','Location','southeast')
nexttile(2);
plot(mean(d2),'LineWidth',2,'Color',"#EDB120")
xlim([0 301])
legend('M-TVF','Location','southeast')
set(gca,'FontSize',16)
xlabel(t,'$t$','FontSize',16,'interpreter','latex')
ylabel(t,'$d_{/mathcal{Y}}(/alpha(t), /tilde{/alpha}(t))$','FontSize',16,'interpreter','latex')
set(f2,'Position',[100 100 420 560])
exportgraphics(f2,'../06_results/figures/error_over_time.pdf','Resolution',300) 
