%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Posture_Mode_Figure9 - The code is to generate figure 9
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear 
addpath('../02_functions/')

%% === Plot 9 Visualization of Clustering and Quantization ===
%%%% --- Load Worker Motion 1 as an Example
load ../01_data/RWP_1_Outcome_300.mat
load ../03_metrics/posture_modes_12.mat
set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

% Compute Mean Sequence
XM = mean_posture_seq(aligned);

%% === 9b Posture Modes ===
% Step 1. Setup the skelecton representation
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
skeleton_data = posture_to_skeleton(posturemode, len1, tree);

% Step 2. Setup the plot configuration
for i = 1:12
    [smin smax] = bounds(squeeze(skeleton_data(:,i,:)));
    mp = (smin+smax)/2;
    skeleton1 = squeeze(skeleton_data(:,i,:))-mp;
    mean(skeleton1);
    skeleton_data_new(:,i,:) = skeleton1;
end

for i =1:12
    figure
    DrawSkeletonSequenceAction(skeleton_data_new(:,i,:),1,'r','k',16, 1, 0, '');
    axis on
    box on
    x(i,:) = get(gca,'XLim');
    y(i,:) = get(gca,'YLim');
    z(i,:) = get(gca,'ZLim');     
end

x1 = min(x(:,1))-0.1;
y1 = min(y(:,1))-0.1;
z1 = min(z(:,1))-0.1;
x2 = max(x(:,2))+0.1;
y2 = max(y(:,2))+0.1;
z2 = max(z(:,2))+0.1;

% Step 3. Final output
h = figure;
tiledlayout(3,4,"TileSpacing","tight","Padding","tight")
for i =1:12
    nexttile
    DrawSkeletonSequenceAction(skeleton_data_new(:,i,:),1,'r','k', 16, 1, 0, '');
    hold on
    plot3([x1 x2],[y2 y1],[z1 z1],'k','LineWidth',1)
    plot3([x1 x2],[y2 y1],[z2 z2],'k','LineWidth',1)
    plot3([x1 x1],[y2 y2],[z1 z2],'k','LineWidth',1)
    plot3([x2 x2],[y1 y1],[z1 z2],'k','LineWidth',1) 
end
set(h,'Position',[100 100 480 420])
exportgraphics(h,'../06_results/figures/posture_mode_12.pdf','Resolution',300) 

%% === 9c Quantization Example ===
% Step 1. Compute Quantization of Individual Sequences
for m = 1:M
    Xm = aligned{m};
    L(m,:) = quantization(Xm,posturemode);
end

% Step 2. Compute Quantization of Mean Sequence
for t = 1:301
    Pm = squeeze(XM(:,t,:));
    for i = 1:12
        d(i) = dist_posture(Pm,squeeze(posturemode(:,i,:)));
    end
    [~,Idx] = min(d);
    Ymean(t) = Idx;
    Xmean(:,t,:) = posturemode(:,Idx,:);
end

% Step 3. Plot Quantized Sequences
f1 = figure;
hold on
I = randperm(60,12);
colororder('gem12');
p1 = plot(L(I,:)','LineWidth',1.5);
p2 = plot(Ymean,'k','LineWidth',2);

ylim([0 12])
xlim([0 300])
xlabel('t')
ylabel('Cluster Number')
legend(p2 ,'Mean')
set(gca,'FontSize',16)
AX = gca;
exportgraphics(AX,'../06_results/figures/ModePlot12_Original_motion12.pdf','Resolution',300)

%% === 9a Sorted Distance Matrix ===
% Step 1. Compute Distance Matrix of Trainig Data
for i = 1:5000
    for j = 1:5000
        if i<j
            D(i,j) = dist_posture(squeeze(YI(:,i,:)),squeeze(YI(:,j,:)));
        elseif i > j
            D(i,j) = D(j,i);
        elseif i == j;
            D(i,j) = 0;
        end       
    end
end

% Step 2. Sort the Distance Matrix by Cluster
dist = D;

numClust = max(data2clusterNew);
startIdx = 1;
for i = 1:numClust
    thisIdx = find(data2clusterNew==i);
    [~,orderIdx] = sort(thisIdx, 'descend');
    endIdx = startIdx + length(thisIdx) - 1;
    sortIdx(startIdx:endIdx) = thisIdx(orderIdx);
    startIdx = startIdx + length(thisIdx);
end
thisIdx = find(data2clusterNew==0);
endIdx = startIdx + length(thisIdx) - 1;
sortIdx(startIdx:endIdx) = thisIdx;
distSorted = dist(sortIdx,sortIdx);

% Step 3. Plot Sorted Distance Matrix
figure
imagesc(distSorted)
axis square
AX = gca;
exportgraphics(AX,'../06_results/figures/Sorted_Dist_Matrix_All_12.pdf','Resolution',300)