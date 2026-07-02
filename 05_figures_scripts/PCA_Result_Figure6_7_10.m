%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% PCA_Result_Figure6_7_10 - The code is to generate figure 6, 7, 10,
% and table 1
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear 

addpath('../02_functions/')
addpath('../03_metrics/')
load ../01_data/RWP_1_Outcome_300.mat

%% Comput ISTVF
[CIS,V_ref,W_ref,mpos,Xc,Yc] = FormISTVF(aligned);
[Ty,M,~] = size(CIS);
set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

%% Sequential PCA
% Spatial PCA
D1 = 10;
[ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,D1);
% FPCA
D2 = 30;
[Us,Vs,Ms,S,ef,ex,SigK] = FullfPCA(ZZ,D2);
% Reconstruction
CIre = PCAReconstruction(S,Us,Ms,UdZ,MuZ);

%% MPCA
addpath('../tensor_toolbox-v3.6/')
[Zf,Mf,Uf] = SeqMPCA(CIS,85);

% Reconstruction
CMPCA = double(ReMPCA(Zf,Uf,Mf));
CMPCA = permute(CMPCA,[2,3,1]);


%% Figure 7 Plot Histogram
[~,D2,D1] = size(S);
SS = reshape(S,[],D1*D2);

% Compute Mean and Variance of PCA Scores
% Mean
MS = mean(SS);
MS = reshape(MS,[D2,D1]);
%Covariance
CS = cov(SS);
CS = diag(CS);
CS1 = reshape(CS,[D2,D1]);

f1 = figure;
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
hL.Location = 'southoutside';
ylabel(h,'Density','interpreter','latex')
set(gcf,'Position',[50 50 750 400])
exportgraphics(f1,'../06_results/figures/histogram.pdf','Resolution',300)

%% Figure 6 Dimension Reduction Compare
%% Figure 6a Reconstruction of ISTVF Functions
% use the 13th element of the ISTVF for the 8th sequence observation as an example 
f2 = figure;
plot(CIS(:,8,13),'linewidth',2)                                             % Original 
hold on
plot(CIre(:,8,13),'linewidth',2)                                            % Sequential Reconstruction
hold on
plot(CMPCA(:,8,13),'linewidth',2)                                           % MPCA Reconstruction
legend('Original','Sequential PCA','MPCA')      
xlabel('Time $t$')
ylabel('Reconstrcuted IS-TVF $G_{/alpha_m}^{(13)}$')
set(gca,'FontSize',16)
set(gcf,'Position',[100 100 560 300])
exportgraphics(f2,'../06_results/figures/PCA_compare_ISTVF.pdf','Resolution',300)

%% Figure 6c Reconstruction of Posture Sequences
Xre_Seq = ISTVF_to_posture(CIre,V_ref,W_ref,mpos);                          % Sequential
Xre_Mpca = ISTVF_to_posture(CMPCA,V_ref,W_ref,mpos);                        % MPCA

[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
skeleton_data_PCA_0 = posture_to_skeleton(aligned{8}, len1, tree); 
skeleton_data_SeqPCA = posture_to_skeleton(Xre_Seq{8}, len1, tree);
skeleton_data_MPCA = posture_to_skeleton(Xre_Mpca{8}, len1, tree);   

f3 = figure;
DrawSkeletonSequenceAction(skeleton_data_PCA_0,30,'r','b',16, 1, -2, 'Original', 0:300);
DrawSkeletonSequenceAction(skeleton_data_SeqPCA,30,'r','k',16, 1, -4, {'Sequential','PCA'});
DrawSkeletonSequenceAction(skeleton_data_MPCA,30,'r','k',16, 1, -6, 'MPCA');
set(gcf,'Position',[100 100 900 480])
exportgraphics(f3,'../06_results/figures/PCA_reconstructed_compare.pdf','Resolution',300) 

%% Figure 6b Reconstrcution Error over Reduced Dimensions
%% Sequential PCA
for k1 = 1:41   % Loop over Spatial Dimension 0 to 40
    if k1 == 1  % Mean Posture Only (Spatial Dimension of 0)
        ZM = reshape(CIS,[Ty*M,40]);
        MuZ = mean(ZM);
        CIre = repmat(MuZ,Ty,1);
        CIre = reshape(CIre,300,1,40);
        % Posture Reconstruction
        Xre_Seq = ISTVF_to_posture(CIre,V_ref,W_ref,mpos);
        % Compute Reconstruction Error
        for m = 1:M
            dm = dist_seq_to_seq(Xc{m},Xre_Seq{1});
            for k2 = 1:61 
                dpca(m,k1,k2) = dm; 
            end
        end
    else
        % Perform Spatial PCA
        [ZZ,MuZ,UdZ] = SpatialPCA(CIS,k1-1);
        for k2 = 1:61   % Loop over Temporal Dimension 0 to 61
            if k2 == 1  % Mean Function Only (Temporal Dimension of 0)
                Ms = mean(ZZ,2);
                Zre = repmat(Ms,1,60,1);
                CIre = SpatialPCARecon(Zre,UdZ,MuZ);
            else
                % Perform FPCA
                D = k2-1;
                [Us,V,Ms,S] = FullfPCA(ZZ,D);
                CIre = PCAReconstruction(S,Us,Ms,UdZ,MuZ);
            end
            % Posture Reconstruction
            Xre_Seq = ISTVF_to_posture(CIre,V_ref,W_ref,mpos);
            % Compute Reconstruction Error
            for m = 1:M
                dpca(m,k1,k2) = dist_seq_to_seq(Xc{m},Xre_Seq{m});
            end
        end
    end
end

%% Compute Mean Reconstruction Error
dpca_mean = squeeze(mean(dpca(:,1:41,1:61)));

d1 = 0:40;
d2 = 0:60;
d = d1'*d2;
d(2:end,1) = 1:40;
di = unique(d);     % Find the Unique Dimension

%% MPCA
for k = 1:21   % Loop over maintained total variance from 80% to 100% 
    [Zf,Mf,Uf] = SeqMPCA(CIS,79+k);
    
    CMPCA = double(ReMPCA(Zf,Uf,Mf));
    CMPCA = permute(CMPCA,[2,3,1]);
    
    % Posture Reconstruction
    Xre_Mpca = ISTVF_to_posture(CMPCA,V_ref,W_ref,mpos);
    
    % Reconstruction Error
    for m = 1:M
        dmpca(k,m) = dist_seq_to_seq(Xc{m},Xre_Mpca{m});
    end
    [DD1,DD2,~] = size(Zf);
    K(k) = DD1*DD2;     % Get the reduced dimension
end

%% Find Minimum Reconstruction of Sequential PCA with Equivalent Reduced Dimension to the MPCA Results
for i =1:length(K)-2
    dpcak(i) = min(dpca_mean(d==K(i)));
end

%% Plot Error over Total Reduced Dimension
f4 = figure;
plot(K(1:19),mean(dmpca(1:19,:),2),'LineWidth',2)
ylabel('Shape Error')
xlabel('Total Dimensions d')
hold on
plot(K(1:19),dpcak(1:19),'LineWidth',2)
ylim([0 5.5]);
legend('MPCA','Sequential PCA')
set(gca,'Fontsize',14)
set(gcf,'Position',[100 100 560 300])
exportgraphics(f4,'../06_results/figures/Compare_shape_error_over_d.pdf','Resolution',300)

%% Figure 10 Sequential PCA Parameter Selection
%% Figure 10b Mech Plot of the Reconstrcution Error
X1 = repmat(d1(2:end),60,1)';
Y1 = repmat(d2(2:end),40,1);
f5 = figure;
mesh(X1,Y1,dpca_mean(2:end,2:end))
xlabel('$d_1$','Interpreter','latex')
ylabel('$d_2$','Interpreter','latex')
zlabel('Reconstruction Error')
view(150,30)
set(gca,'Fontsize',14)
exportgraphics(f5,'../06_results/figures/mesh_SeqPCA_error_over_d1_d2.pdf','Resolution',300)

%% Figure 10a Reconstruction over Funtional Dimensions with 2 fixed Spatial Dimension
d1 = [5,10];        % Two Fixed Spatial Dimension Selection
for i = 1:2
    k1 = d1(i);
    % Perform Spatial PCA
    [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,k1);
    % Perform FPCA
    for k2 = 1:61   % Loop over Reduced Temporal Dimension fro m0 to 60.
        if k2 == 1  % Mean Function Only (Temporal Dimension of 0)
            Ms = mean(ZZ,2);
            Zre = repmat(Ms,1,60,1);
            CIre = SpatialPCARecon(Zre,UdZ,MuZ);
        else
            % FPCA
            D = k2-1;
            [Us,V,Ms,S,ef,ex,SigK] = FullfPCA(ZZ,D);
            CIre = PCAReconstruction(S,Us,Ms,UdZ,MuZ);
        end
        % Posture Reconstruction
        Xre_fpca = ISTVF_to_posture(CIre,V_ref,W_ref,mpos);
        % Compute Reconstruction Error
        for m = 1:M
            dfpca(k2,m,i) = dist_seq_to_seq(Xc{m},Xre_fpca{m}); 
        end
        % Perform Two-Sample Test 
        if i == 2 && mod(k2-1,5)==0
            p(fix((k2-1)/5)+1) = twosampletest(Xc, Xre_fpca, 10000);
        end
    end
end

% Plot Average Error over Temporal Dimension
f6 = figure;
plot([0:60],squeeze(mean(dfpca,2))./mean(squeeze(dfpca(1,:,:)),1),'LineWidth',2)
set(gca,'Fontsize',14)
legend('$d_1=5$','$d_1=10$','Interpreter','latex')
xlabel('Selection of $d_2$','Interpreter','latex')
ylabel('Normalized Shape Error','Interpreter','latex')
exportgraphics(f6,'../06_results/figures/SeqPCA_shape_error_over_d2.pdf','Resolution',300)

%% Figure 10c Plot p-Value over Temporal Dimension
f7 = figure;
plot([0:5:60],p,'LineWidth',2)
set(gca,'Fontsize',14)
xlabel('Selection of $d_2$','Interpreter','latex')
ylabel('p-value','Interpreter','latex')
title('$/alpha$ vs $/tilde{/alpha}$','Interpreter','latex')
exportgraphics(f7,'pvalue_d2_originalVSreconstruction.pdf','Resolution',300)


%% Table 1 Dimension Reduction Compare
load ../01_data/RWP_1_Outcome_300.mat

[CIS,V_ref,W_ref,mpos,Xc,Yc] = FormISTVF(aligned);
[Ty,M,~] = size(CIS);
set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

Result = zeros(4,3);
%% 1. Sequential PCA
% Spatial PCA
D1 = 5;
[ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,D1);
% FPCA
D2 = 10;
[Us,Vs,Ms,S,ef,ex,SigK] = FullfPCA(ZZ,D2);
% PCA Reconstruction
CIre = PCAReconstruction(S,Us,Ms,UdZ,MuZ);
% Posture Reconstruction
Xre_Seq = ISTVF_to_posture(CIre,V_ref,W_ref,mpos);

% Compute Reconstrcution Error
for m = 1:M
    dm_spca(m) = dist_seq_to_seq(Xc{m},Xre_Seq{m});
end

% Mean Reconstruction Error
Result(1,1) = D1;
Result(1,2) = D2;
Result(1,3) =  mean(dm_spca);

%% 2. MPCA
addpath('./tensor_toolbox-v3.6/')
[Zf,Mf,Uf] = SeqMPCA(CIS,90);
% MPCA Reconstruction
CMPCA = double(ReMPCA(Zf,Uf,Mf));
CMPCA = permute(CMPCA,[2,3,1]);
% Posture Reconstruction
Xre_Mpca = ISTVF_to_posture(CMPCA,V_ref,W_ref,mpos);

% Compute Reconstrcution Error
for m = 1:M
    dm_mpca(m) = dist_seq_to_seq(Xc{m},Xre_Mpca{m});
end

% Mean Reconstruction Error
Result(2,1) = size(Zf,1);
Result(2,2) = size(Zf,2);
Result(2,3) =  mean(dm_mpca);

%% 3. AE+FPCA
% Train AE
hiddenSize = D1;
CIS_flatten = reshape(CIS, Ty*M,[]);
ae = trainAutoencoder(CIS_flatten', hiddenSize, ...
    'DecoderTransferFunction','purelin', ...
    'SparsityRegularization', 1, ...
    'L2WeightRegularization', 0.001, ...
    'SparsityProportion', 0.5, ...
    'MaxEpochs', 500, ...
    'ShowProgressWindow', false);

% Spatial Dimension
Z_AE_flattened = encode(ae, CIS_flatten')';
Z_AE = reshape(Z_AE_flattened, Ty, M, []);

% Temporal Dimension
[Uf_AE,Vf_AE,Mf_AE,Sf_AE] = FullfPCA(Z_AE,D2);

% Reconstruction
% FPCA Reconstruction
for m = 1:M
    for k = 1:D1
        RS = Sf_AE(m,:,k);
        Z_AE_re(:,k,m) = Uf_AE(:,:,k)*RS'+Mf_AE(k,:)';    
    end 
end

% AE Decode
Z_AE_re = permute(Z_AE_re, [1,3,2]);
Z_AE_re_flattened = reshape(Z_AE_re, Ty*M,[]);

CI_AE_flanttend = decode(ae,Z_AE_re_flattened')';
CI_AE = reshape(CI_AE_flanttend,Ty,M,[]);

% Posture Reconstruction
Xre_AE = ISTVF_to_posture(CI_AE,V_ref,W_ref,mpos);

% Compute Reconstruction Error
for m = 1:M
    dm_ae(m) = dist_seq_to_seq(Xc{m},Xre_AE{m});
end

% Mean Reconstruction Error
Result(3,1) = D1;
Result(3,2) = D2;
Result(3,3) =  mean(dm_ae);

%% 4. VAE+FPCA
% Train VAE
opts = struct('latentDim',D1);
vae = trainVAE(CIS_flatten, opts);
Z_VAE = double(vae.encode(CIS_flatten));
Z_VAE = reshape(Z_VAE, Ty, M, []);
% FPCA
[Uf_VAE,Vf_VAE,Mf_VAE,Sf_VAE] = FullfPCA(Z_VAE,D2);

% FPCA Reconstruction
for m = 1:M
    for k = 1:D1
        RS = Sf_VAE(m,:,k);
        Z_VAE_re(:,k,m) = Uf_VAE(:,:,k)*RS'+Mf_VAE(k,:)';    
    end 
end

% VAE Decode
Z_VAE_re = permute(Z_VAE_re, [1,3,2]);
Z_VAE_re_flattened = reshape(Z_VAE_re, Ty*M,[]);

CI_VAE_flanttend = vae.decode(Z_VAE_re_flattened);
CI_VAE = reshape(CI_VAE_flanttend,Ty,M,[]);

% Posture Reconstruction
Xre_VAE = ISTVF_to_posture(CI_VAE,V_ref,W_ref,mpos);

% Compute Reconstruction Error
for m = 1:M
    dm_vae(m) = dist_seq_to_seq(Xc{m},Xre_VAE{m});
end

% Mean Reconstruction Error
Result(4,1) = D1;
Result(4,2) = D2;
Result(4,3) =  mean(dm_vae);

table1 = table(Result);
