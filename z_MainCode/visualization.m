clear all;

addpath('./MotionCode/');

load RWP_1_Outcome_300.mat
% load Generation\Generation\Full\GenSeqFull__Motion1_ITVF_FPCA.mat
set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

%% figure 1
X1 = aligned{10};
X2 = posture_sequence{10};

X1(:,end+1,:) = X1(:,end,:);
X2(:,end+1,:) = X2(:,end,:);

[~, len1] = skeleton_to_posture(Ref_pos_data, tree);

skeleton_data1 = posture_to_skeleton(X1, len1, tree);   
skeleton_data2 = posture_to_skeleton(X2, len1, tree);  

f = figure;
DrawSkeletonSequenceAction_SKKU(skeleton_data1,30,'r','b', 16, 1, -2*1, '(1)', 0:300);
DrawSkeletonSequenceAction_SKKU(skeleton_data2,30,'r','k', 16, 1, -2*2, '(2)');
set(gcf,'Position',[100 100 900 350])

exportgraphics(f,'alignment.pdf','Resolution',300) 

f10 = figure;
DrawSkeletonSequenceAction_SKKU(skeleton_data1,45,'r','b', 1,0,'', 0:300);
view([65 30])
set(gcf,'Position',[100 100 350 400])
exportgraphics(f10,'motion_sequence.eps','Resolution',300) 
%% figure 8
[CIS,V_ref,W_ref,mpos,Xc,Yc,Cm] = FormITVF(aligned);

figure
yyaxis left
plot(Cm(:,8,2),'linewidth',2)
ylabel('S-TVF value')
% yticks([-0.15:0.15])
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
exportgraphics(ax,'ITVF1.pdf','Resolution',300) 

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
% yticks([-0.05:0.01:0.05])
xlabel('Time $t$','Interpreter','latex')
legend('S-TVF','IS-TVF')
set(gca,'FontSize',14)
set(gcf,'Position',[100 100 560 250])
ax = gca;
exportgraphics(ax,'ITVF2.pdf','Resolution',300) 

%% PCA
D1 = 10;
[ZZ,MuZ,UdZ,SigZ] = SeqPCA(CIS,D1);

figure
plot(diag(SigZ),'LineWidth',2)
xlabel('Number of Eigenvectors')
ylabel('Eigenvalue')
set(gca,'FontSize',18)
ax = gca;
exportgraphics(ax,'Eigenvalue_PCA.pdf','Resolution',300) 
figure
plot(cumsum(diag(SigZ))/sum(diag(SigZ)),'LineWidth',2)
xlabel('Number of Eigenvectors')
ylabel('Percentage of Total Variance')
set(gca,'FontSize',16)
ax = gca;
exportgraphics(ax,'Eigenvalue_PCA_Percentage.eps','Resolution',300) 


for i = 1:3   
    for s = 1:5
        S = [-2:2];
        Us = UdZ(:,i)'*S(s) + MuZ;
        Us = reshape(Us,[20,2]);
        Y_m(1,:,:) = V_ref.*Us(:,1) + W_ref.*Us(:,2);    
        posture_re = TVF_Recon_Geodesic(Y_m, mpos);
        posture_s(:,s,:) = posture_re(:,2,:);
        postureI{i} = posture_s; 
        skeleton_data{i} = posture_to_skeleton(postureI{i}, len1, tree);
    end
end
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
% skeleton_data1 = posture_to_skeleton(postureI{1}, len1, tree);
% skeleton_data2 = posture_to_skeleton(postureI{2}, len1, tree);
% skeleton_data3 = posture_to_skeleton(postureI{3}, len1, tree);
ff = figure(100)
tiledlayout(3,5,"TileSpacing","tight")
for i = 1:3
    skeleton_data1 = skeleton_data{i};
    for j = 1:5
        if j ~=3    
            nexttile
            DrawSkeletonSequenceAction_SKKU(skeleton_data1(:,j,:),1,'r','b', 16,1, 0, '');
            if i == 1
                title({['s=',num2str(S(j))], ''},'FontSize',16)
            end
        else
            nexttile
            DrawSkeletonSequenceAction_SKKU(skeleton_data1(:,j,:),1,'r','k', 16,1, 0, '');
            if i == 1
                title({'mean', 'posture'},'FontSize',18)
            end
        end
    end
end
exportgraphics(ff,'PCA_direction.pdf','Resolution',300)
% %% Train-Test Split
% I = randperm(60);
% Z1 = ZZ(:,I(1:45),:);
% Z2 = ZZ(:,I(46:60),:);

Ty = 300;
CInew = squeeze(ZZ(:,7,:))*UdZ(:,1:10)' + MuZ;
Cnew = [CInew(1,:,:); diff(CInew)];
Cnew = reshape(Cnew,[Ty,20,2]);
for t = 1:Ty
    Y_new(t,:,:) = V_ref.*squeeze(Cnew(t,:,1))' + W_ref.*squeeze(Cnew(t,:,2))';    
end
posture_re_new1 = TVF_Recon_Geodesic(Y_new,mpos);
X_PCA_1 = posture_re_new1;

[X2,Y2,C2] = ITVF_to_posture(CIS,V_ref,W_ref,mpos);

% posture_re_1 = Reconstrunction_PostureSeq(Y2, mpos);
X_PCA_0 = X2{7};

skeleton_data_PCA = posture_to_skeleton(X_PCA_1, len1, tree);   
skeleton_data_PCA_0 = posture_to_skeleton(X_PCA_0, len1, tree);   

dist_seq_to_seq(X_PCA_0,X_PCA_1)
f2 = figure;
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_PCA_0,30,'r','b',16, 1, -2*1, 'Original', 0:300);
DrawSkeletonSequenceAction_SKKU_label(skeleton_data_PCA,30,'r','k',16, 1, -2*2, {'PCA','recons-','truction'});
set(gcf,'Position',[100 100 900 350])
exportgraphics(f2,'PCA_reconstruction.pdf','Resolution',300) 

%% Figure 8
%% Full FPCA
% Set # of coefficients
D = 3;
[U,V,M,S,ef,ex,SigK] = FullfPCA(ZZ,D);
% for k = 1:5
%     figure
%     subplot(1,2,1)
%     plot(SigK(1:40,k),'LineWidth',2)
%     xlabel('Number of Eigenvectors')
%     ylabel('Eigenvalue')
%     set(gca,'FontSize',16)
%     subplot(1,2,2)
%     plot(cumsum(SigK(1:40,k))/sum(SigK(:,k)),'LineWidth',2)
%     xlabel('Number of Eigenvectors')
%     ylabel('Percentage of Total Variance')
%     ylim([0,1])
%     set(gca,'FontSize',16)
% end
% 
figure
plot(SigK(1:20,1),'LineWidth',2)
xticks([0:5:20])
xlabel('Number of Eigenvectors')
ylabel('Eigenvalue')
set(gca,'FontSize',18)
ax = gca;
exportgraphics(ax,'Eigenvalue_FPCA.eps','Resolution',300) 
figure
plot(cumsum(SigK(1:60,1))/sum(SigK(:,1)),'LineWidth',2)
xticks([0:5:60])
xlabel('Number of Eigenvectors')
ylabel('Percentage of Total Variance')
% ylim([0,1])
set(gca,'FontSize',16)
ax = gca;
exportgraphics(ax,'Eigenvalue_FPCA_Percentage.eps','Resolution',300) 


f5 = figure;
h1 = tiledlayout(2,2,"TileSpacing",'tight','Padding','compact');
nexttile
plot(M(1,:),'LineWidth', 2);ylim([-4 4])
title('$\mu^{(1)}$','FontSize',16)
nexttile
plot(U(:,1,1),'LineWidth',2);ylim([-0.2 0.2])
title('$\beta_{1}^{(1)}$','FontSize',16)
nexttile
plot(U(:,2,1),'LineWidth',2);ylim([-0.2 0.2])
title('$\beta_{2}^{(1)}$','FontSize',16)
nexttile
plot(U(:,3,1),'LineWidth',2);ylim([-0.2 0.2])
title('$\beta_{3}^{(1)}$','FontSize',16)

xlabel(h1,'Time $t$','FontSize',16,'interpreter','latex')
set(gcf,'Position',[100 100 750 420])
exportgraphics(f5,'FPCA_Direction.eps','Resolution',300) 

for k = 1:10
    Znew(:,k) = U(:,:,k)*S(8,:,k)'+M(k,:)';
end

%% Figure 9d
f4 = figure;
h=tiledlayout(1,3, 'Padding', 'none', 'TileSpacing', 'compact'); 
nexttile;
plot(ZZ(:,8,1),'LineWidth',3);hold on;plot(Znew(:,1),'LineWidth',3)
ylim([-3 5])
%xlabel('Time $t$','Interpreter','latex')
ylabel('$\mathbf{H}_{\alpha_m}^{(1)}$','Interpreter','latex')
set(gca,'FontSize',14)
nexttile
plot(ZZ(:,8,2),'LineWidth',3);hold on;plot(Znew(:,2),'LineWidth',3)
ylim([-3 5])
%xlabel('Time $t$','Interpreter','latex')
ylabel('$\mathbf{H}_{\alpha_m}^{(2)}$','Interpreter','latex')
set(gca,'FontSize',14)
nexttile
plot(ZZ(:,8,3),'LineWidth',3);hold on;plot(Znew(:,3),'LineWidth',3)
ylim([-3 5])
%xlabel('Time $t$','Interpreter','latex')
ylabel('$\mathbf{H}_{\alpha_m}^{(3)}$','Interpreter','latex')
set(gca,'FontSize',14)
% nexttile
% plot(ZZ(:,8,4),'LineWidth',3);hold on;plot(Znew(:,4),'LineWidth',3)
% ylim([-3 5])
% %xlabel('Time $t$','Interpreter','latex')
% ylabel('$\mathbf{H}_{\alpha_m}^{(4)}$','Interpreter','latex')
% set(gca,'FontSize',12)
% nexttile
% plot(ZZ(:,8,5),'LineWidth',3);hold on;plot(Znew(:,5),'LineWidth',3)
% ylim([-3 5])
% %xlabel('Time $t$','Interpreter','latex')
% ylabel('$\mathbf{H}_{\alpha_m}^{(5)}$','Interpreter','latex')
% set(gca,'FontSize',12)
% nexttile
% plot(ZZ(:,8,6),'LineWidth',3);hold on;plot(Znew(:,6),'LineWidth',3)
% ylim([-3 5])
%xlabel('Time $t$','Interpreter','latex')
% ylabel('$\mathbf{H}_{\alpha_m}^{(6)}$','Interpreter','latex')
%set(gca,'FontSize',12)

hL = legend(nexttile(2),'Observation','Reconstruction','Orientation','horizontal','FontSize',14); 
% % Move the legend to the right side of the figure
hL.Location = 'northoutside';
xlabel(h,'Time $t$','Interpreter','latex','FontSize',16)
ylabel(h,'PCA coefficient function','Interpreter','latex','FontSize',16)
set(f4,'Position',[100 100 1100 250])

exportgraphics(f4,'FPCA_H_reconstruction_1.eps','Resolution',300) 
exportgraphics(f4,'FPCA_H_reconstruction_1.pdf','Resolution',300) 

CInew_f = Znew(:,:)*UdZ(:,1:10)' + MuZ;

Ty = 300;
Cnew_f = [CInew_f(1,:,:); diff(CInew_f)];
Cnew_f = reshape(Cnew_f,[Ty,20,2]);
for t = 1:Ty
    Y_new_f(t,:,:) = V_ref.*squeeze(Cnew_f(t,:,1))' + W_ref.*squeeze(Cnew_f(t,:,2))';    
end

posture_re_new1_f = Reconstrunction_PostureSeq(Y_new_f, mpos);
X_FPCA_1 = posture_re_new1_f;

% Cm = C2(:,8,:);
% Cm = reshape(Cm,[Ty,20,2]);
% for t = 1:Ty
%     Y_FPCA(t,:,:) = V_ref.*squeeze(Cm(t,:,1))' + W_ref.*squeeze(Cm(t,:,2))';
% end
% 
% posture_re_1_f = Reconstrunction_PostureSeq(Y_FPCA/100, mpos);
X_FPCA_0 = X2{8};

skeleton_data_FPCA = posture_to_skeleton(X_FPCA_1, len1, tree);   
skeleton_data_FPCA_0 = posture_to_skeleton(X_FPCA_0, len1, tree);   

%% Figure 11
addpath('..\tensor_toolbox-v3.6\')
[Zf,Mf,Uf] = SeqMPCA(CIS,85);

XMPCA = double(ReMPCA(Zf,Uf,Mf));
CMPCA = permute(XMPCA,[2,3,1]);

CInew_m = CMPCA(:,8,:);
Cnew_m = [CInew_m(1,:,:); diff(CInew_m)];
Cnew_m = reshape(Cnew_m,[Ty,20,2]);
for t = 1:Ty
    Y_MPCA(t,:,:) = V_ref.*squeeze(Cnew_m(t,:,1))' + W_ref.*squeeze(Cnew_m(t,:,2))';
end

posture_re_1_m = Reconstrunction_PostureSeq(Y_MPCA, mpos);
X_MPCA_1 = posture_re_1_m;

skeleton_data_MPCA_1 = posture_to_skeleton(X_MPCA_1, len1, tree);   

f3 = figure;
DrawSkeletonSequenceAction_SKKU(skeleton_data_FPCA_0,30,'r','b', 1, -2, 'Original', 0:300);
DrawSkeletonSequenceAction_SKKU(skeleton_data_FPCA,30,'r','k', 1, -4, {'Sequential','PCA'});
DrawSkeletonSequenceAction_SKKU(skeleton_data_MPCA_1,30,'r','k', 1, -6, 'MPCA');
set(gcf,'Position',[100 100 900 480])
exportgraphics(f3,'MPCA_reconstructed.eps','Resolution',300) 

%% Figrue 9
figure
plot(CIS(:,8,13),'linewidth',2)
hold on
plot(CInew_f(:,13),'linewidth',2)
hold on
plot(CInew_m(:,13),'linewidth',2)
legend('Orignal','Sequential PCA','MPCA')
xlabel('Time $t$')
ylabel('Reconstrcuted IS-TVF $G_{\alpha_m}^{(13)}$')
set(gca,'FontSize',16)
set(gcf,'Position',[100 100 560 300])
ax = gca;
exportgraphics(ax,'MPCA_compare_1.pdf','Resolution',300)

figure
plot(CIS(:,8,14),'linewidth',2)
hold on
plot(CInew_f(:,14),'linewidth',2)
hold on
plot(CInew_m(:,14),'linewidth',2)
legend('Orignal','Sequential PCA','MPCA')
xlabel('Time $t$','Interpreter','latex')
ylabel('Reconstrcuted ITVF $G_{\alpha_m}^{(14)}$','Interpreter','latex')
set(gca,'FontSize',16)
ax = gca;
exportgraphics(ax,'MPCA_compare_2.eps','Resolution',300) 

for i = 1:1000
    d4(i) = dist_seq_to_seq(X_FPCA_0(:,1:i,:),X_FPCA_1(:,1:i,:));
end

% figure
% plot(d4,'linewidth',2)
% set(gca,'FontSize',14)
% ax = gca;
% exportgraphics(ax,'.\paper\error over time(MPCA).png','Resolution',300) 
% 
% for i = 1:1000
%     d5(i) = dist_seq_to_seq(X_FPCA_0(:,1:i,:),X_MPCA_1(:,1:i,:));
% end

% figure
% plot(d4,'linewidth',3)
% hold on
% plot(d5,'linewidth',3)
% legend('Separated PCA','MPCA')
% set(gca,'FontSize',18)
% ax = gca;
% exportgraphics(ax,'.\paper\error over time(FPCA vs MPCA).png','Resolution',300) 

% figure
% tiledlayout(5,4, 'Padding', 'none', 'TileSpacing', 'compact'); 
% for i=1:5 
%     for j = 1:4
%         nexttile
%         zn = normalize(Zf(i,j,:));
%         histogram(zn,'Normalization','probability')
%         xlim([-5 5]);
%         ylim([0 0.5])
%     end
% end
% ax = gcf;
% exportgraphics(ax,'.\paper\histogram.eps','Resolution',300)

[~,D2,D1] = size(S);
SS = reshape(S,[],D1*D2);
MS = mean(SS);
MS = reshape(MS,[D2,D1]);
CS = cov(SS);
CS = diag(CS);
CS1 = reshape(CS,[D2,D1]);



f11 = figure;
h = tiledlayout(3,3, 'Padding', 'compact', 'TileSpacing', 'compact'); 
for d1=1:3    
    for d2=1:3
        nexttile
        sigmax = std(S(:,d2,d1));
        mx = mean(S(:,d2,d1));
        binloc = (-3.5:0.5:3.5)*sigmax+mx;
        histogram(S(:,d2,d1),"Normalization","pdf",'BinEdges',binloc)
        hold on;
        ax = gca;
        x = linspace(ax.XLim(1), ax.XLim(2), 1000);
        plot(x, normpdf(x,0,sqrt(CS1(d2,d1))), 'LineWidth', 2 ,'Color',	"#0072BD")
        hold on
        line(x,interp1(ex(:,d2,d1),ef(:,d2,d1),x),'LineWidth',2,'Color',"#D95319")
        set(gca,'FontSize',12)
    end
end
hL = legend(nexttile(8),'Histogram','Gaussian density','Non-parametric density','Orientation','horizontal'); 
% Move the legend to the right side of the figure
hL.Location = 'southoutside';
%xlabel(h,'PCA coefficient','interpreter','latex')
ylabel(h,'Density','interpreter','latex')
set(gcf,'Position',[50 50 750 400])
% a = annotation(gcf,'textarrow',...
%    [0.52 0.5], [0.95 0.5],...
%    'String','Temporal Dimension','Interpreter','latex', 'HeadStyle', 'none', 'LineStyle', 'none',...
%    'FontSize',14, 'color','k','FontWeight','bold', 'TextRotation',0);
% b = annotation(gcf,'textarrow',...
%     [0.97 0.5], [0.43 0.5],...
%     'String','Spatial Dimension','Interpreter','latex',  'HeadStyle', 'none', 'LineStyle', 'none',...
%     'FontSize',14, 'color','k','FontWeight','bold', 'TextRotation',90);
% set(gcf,'Position',[100 100 900 480])
exportgraphics(f11,'histogram.pdf','Resolution',300)