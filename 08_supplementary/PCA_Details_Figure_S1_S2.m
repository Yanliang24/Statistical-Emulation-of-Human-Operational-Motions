%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PCA_Details_Figure_S1_S2 - The code is to generate figure 1 and
% figure 2 in Supplementary Material
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear
addpath('../02_functions/')

%% load Load Worker Motion 1 as an Example
load ../01_data/RWP_1_Outcome_300.mat
set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

%% === Figure S1 Spatial PCA ===

%%%% --- Perform Spatial PCA ---
% Step 1. Compute ISTVF
[CIS,V_ref,W_ref,mpos,Xc,Yc,Cm] = FormISTVF(aligned);

% Step 2. Spatial PCA
D1 = 10;
[ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,D1);

% Step 3. Reconstruction
Ty = size(CIS, 1);
Inx = 7;        % Random Selected as an Example
CIre = squeeze(ZZ(:,Inx,:))*UdZ(:,1:10)' + MuZ;     % PCA Reconstruction
% ISTVF Reconstruction
Cre = [CIre(1,:,:); diff(CIre)];                    
Cre = reshape(Cre,[Ty,20,2]);
for t = 1:Ty                                        
    Y_re(t,:,:) = V_ref.*squeeze(Cre(t,:,1))' + W_ref.*squeeze(Cre(t,:,2))';    
end
posture_re_pca = STVF_Recon(Y_re,mpos);
x_re_pca = posture_re_pca;

%%%% --- Plot PCA Results ---
% 1a Eigenvalues
f1 = figure;
plot(diag(SigZ),'LineWidth',2)
xlabel('Number of Eigenvectors')
ylabel('Eigenvalue')
set(gca,'FontSize',18)
exportgraphics(f1,'Eigenvalue_PCA.pdf','Resolution',300) 

% 1b PCA Directions
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
for i = 1:3   
    for s = 1:5
        S = [-2:2];
        Us = UdZ(:,i)'*S(s) + MuZ;
        Us = reshape(Us,[20,2]);
        Y_m(1,:,:) = V_ref.*Us(:,1) + W_ref.*Us(:,2);    
        posture_re = STVF_Recon(Y_m, mpos);
        posture_s(:,s,:) = posture_re(:,2,:);
        postureI{i} = posture_s; 
        skeleton_data{i} = posture_to_skeleton(postureI{i}, len1, tree);
    end
end

skeleton_data1 = posture_to_skeleton(postureI{1}, len1, tree);
skeleton_data2 = posture_to_skeleton(postureI{2}, len1, tree);
skeleton_data3 = posture_to_skeleton(postureI{3}, len1, tree);
f2 = figure;
tiledlayout(3,5,"TileSpacing","tight")
for i = 1:3
    skeleton_data1 = skeleton_data{i};
    for j = 1:5
        if j ~=3    
            nexttile
            DrawSkeletonSequenceAction(skeleton_data1(:,j,:),1,'r','b', 16 ,1, 0, '');
            if i == 1
                title({['s=',num2str(S(j))], ''},'FontSize',16)
            end
        else
            nexttile
            DrawSkeletonSequenceAction(skeleton_data1(:,j,:),1,'r','k', 16,1, 0, '');
            if i == 1
                title({'mean', 'posture'},'FontSize',18)
            end
        end
    end
end
exportgraphics(ff,'../06_results/figures/PCA_direction.pdf','Resolution',300)

% 1c Reconstruction
x_pca = Xc{Inx};
skeleton_data_0 = posture_to_skeleton(x_pca, len1, tree);   
skeleton_data_PCA = posture_to_skeleton(x_re_pca, len1, tree);   

f3 = figure;
DrawSkeletonSequenceAction_label(skeleton_data_0,30,'r','b',16, 1, -2*1, 'Original', 0:300);
DrawSkeletonSequenceAction_label(skeleton_data_PCA,30,'r','k',16, 1, -2*2, {'PCA','recons-','truction'});
set(gcf,'Position',[100 100 900 350])
exportgraphics(f3,'../06_results/figures/PCA_reconstruction.pdf','Resolution',300) 


%% === Figure S2 FPCA===
%%%% --- Perform FPCA ---
% Step 1. Apply FPCA
D2 = 30;                % Set # of coefficients
[U,V,M,S,ef,ex,SigK] = FullfPCA(ZZ,D2);

%Step 2. FPCA Reconstruction
Inx_element = 8;
for k = 1:10
    Znew(:,k) = U(:,:,k)*S(Inx_element,:,k)'+M(k,:)';
end

%%% --- Plot FPCA Results ---
% 2a Eigenvalues
f4 = figure;
plot(SigK(1:20,1),'LineWidth',2)
xticks([0:5:20])
xlabel('Number of Eigenvectors')
ylabel('Eigenvalue')
set(gca,'FontSize',18)
ax = gca;
exportgraphics(f4,'../06_results/figures/Eigenvalue_FPCA.pdf','Resolution',300) 

% 2b Mean and Basis Functions 
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
exportgraphics(f5,'../06_results/figures/FPCA_Direction.pdf','Resolution',300) 


% 2c Reconstructed Functions
f6 = figure;
h=tiledlayout(1,3, 'Padding', 'none', 'TileSpacing', 'compact'); 
nexttile;
plot(ZZ(:,8,1),'LineWidth',3);hold on;plot(Znew(:,1),'LineWidth',3)
ylim([-3 5])
ylabel('$\mathbf{H}_{\alpha_m}^{(1)}$','Interpreter','latex')
set(gca,'FontSize',14)
nexttile
plot(ZZ(:,8,2),'LineWidth',3);hold on;plot(Znew(:,2),'LineWidth',3)
ylim([-3 5])
ylabel('$\mathbf{H}_{\alpha_m}^{(2)}$','Interpreter','latex')
set(gca,'FontSize',14)
nexttile
plot(ZZ(:,8,3),'LineWidth',3);hold on;plot(Znew(:,3),'LineWidth',3)
ylim([-3 5])
ylabel('$\mathbf{H}_{\alpha_m}^{(3)}$','Interpreter','latex')
set(gca,'FontSize',14)

hL = legend(nexttile(2),'Observation','Reconstruction','Orientation','horizontal','FontSize',14); 
hL.Location = 'northoutside';
xlabel(h,'Time $t$','Interpreter','latex','FontSize',16)
ylabel(h,'PCA coefficient function','Interpreter','latex','FontSize',16)
set(f6,'Position',[100 100 1100 250]) 
exportgraphics(f6,'../06_results/figures/FPCA_H_reconstruction.pdf','Resolution',300) 

