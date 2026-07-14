%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Posture_Validity_KDE_Figure8 - The code is to generate figure 8
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear 
addpath('../03_metrics/')

%% === Load Worker Data as Example ===
X = [];
for s = 1:5
    filename = sprintf('../01_data/RWP_%d_Outcome_300.mat', s);   
    load(filename, 'aligned','tree')
    X = [X, aligned];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Exercise Data
% load ../01_Data/MotionNew_Outcome_800.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% --- Select Key Joints ---
if tree(1,1) == 1                       % Exercise Motion
    I = 10;
    Test_Id(1,:) =  [5  8];             % Neck
    Test_Id(2,:) =  [7  12];            % Right Shoulder
    Test_Id(3,:) =  [6  9];             % Left Shoulder
    Test_Id(4,:) =  [12 13];            % Right Elbow
    Test_Id(5,:) =  [9  10];            % Left Elbow
    Test_Id(6,:) =  [3  18];            % Right Hip
    Test_Id(7,:) =  [2  15];            % Left Hip
    Test_Id(8,:) =  [18 19];            % Right Knee
    Test_Id(9,:) =  [15 16];            % Left Knee 
    Test_Id(10,:) = [4  5];             % Spine
elseif tree(1,1) == 21                  % Worker Motion
    I = 9;                              % No Spine
    Test_Id(1,:) =  [11 14];            % Neck
    Test_Id(2,:) =  [12 15];            % Right Shoulder
    Test_Id(3,:) =  [13 18];            % Left Shoulder
    Test_Id(4,:) =  [18 19];            % Right Elbow
    Test_Id(5,:) =  [15 16];            % Left Elbow
    Test_Id(6,:) =  [3  6];             % Right Hip
    Test_Id(7,:) =  [4  8];             % Left Hip
    Test_Id(8,:) =  [6  7];             % Right Knee
    Test_Id(9,:) =  [8  9];             % Left Knee 
end

%%%% --- Collect Individual Postures ---
M = size(X,2);
T = size(X{1},2);
Y = [];
for i = 1:M
    Y = [Y X{i}];
end

%%%% --- Sample N postures for training ---
% N = M*T;
N = 10000;
idx = randperm(M*T);
Ys = Y(:,idx(1:N),:);
f = figure(100);
tiledlayout(1,4,"TileSpacing","tight","Padding","tight")

%%%% --- Kernel Desnsity Estimation
for i = 1:I     % Loop over i-th key joint
    % Step 1. Compute the Relative Coordinates
    for j = 1:N
        Z(j,:) = get_coordinate(squeeze(Ys(Test_Id(i,1),j,:))',squeeze(Ys(Test_Id(i,2),j,:))');
    end
    % Step 2. Set Mesh Grid for Empirical Estimation
    [theta, phi] = meshgrid(linspace(0, pi, 150), linspace(0, 2*pi, 300));
    xq = sin(theta) .* cos(phi);
    yq = sin(theta) .* sin(phi);
    zq = cos(theta);
    query_points = [xq(:), yq(:), zq(:)];

    % Step 3. Kernel Density Estimation 
    [f_hat, kappa] = spherical_kde(Z, [], query_points);    
    f_hat_grid = reshape(f_hat, size(xq));
    % Step 4. Compute Confidence Region
    t_alpha = spherical_kde_confidence_region(Z, kappa, 0.05);
    
    % Step 5. Visualization for Selected Key Joints (Figure 8)
    if ismember(i, [2, 4, 6, 8])
        nexttile
        % figure
        surf(xq, yq, zq, f_hat_grid, 'EdgeColor', 'none');
        hold on;
        scatter3(Z(:,1), Z(:,2), Z(:,3), 10, 'k', 'filled'); % data points
        axis equal;
        axis off
        % colorbar;
        % title('Spherical Kernel Density Estimate');
        % xlabel('X'); ylabel('Y'); zlabel('Z');
        view(-120, 60)
        camzoom(1.2)
        mask = f_hat_grid >= t_alpha;
        surf(xq .* mask, yq .* mask, zq .* mask, ...
         'FaceColor', 'cyan', 'FaceAlpha', 0.4, 'EdgeColor', 'none');
    end
    KernelVMF(i).Z = Z;
    KernelVMF(i).kappa = kappa;
    KernelVMF(i).t_alpha = t_alpha;
end

%%%% --- Plot Configuration ---
lgd = legend('','Sample Points', 'Confidence Region','FontSize',16,'Location','north','Orientation','horizontal');
lgd.Position = [0.25,0.88,0.44,0.12];
set(f,"Position",[50 50 1000 300])
c = colorbar;
c.FontSize = 16;

if tree(1,1) == 21    
    exportgraphics(f,'../06_results/figures/Kernel_Dist.pdf')
    save('../03_metrics/Estimated_ROW.mat','KernelVMF')
elseif tree(1,1) == 1
    save('../03_metrics/Estimated_ROW_New.mat','KernelVMF')
end