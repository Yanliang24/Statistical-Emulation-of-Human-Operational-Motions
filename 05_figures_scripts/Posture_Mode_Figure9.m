% clear 
addpath('./MotionCode/')
addpath('./02_Functions/')

%% Visualization
load ./01_Data/RWP_1_Outcome_300.mat
load ./03_Metrics/posture_modes_12.mat
set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

XM = mean_posture_seq(aligned);

[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
skeleton_data = posture_to_skeleton(posturemode, len1, tree);

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
exportgraphics(h,'posture_mode_12.pdf','Resolution',300) 

for m = 1:M
    Xm = aligned{m};
    L(m,:) = quantization(Xm,posturemode);
end

for t = 1:301
    Pm = squeeze(XM(:,t,:));
    for i = 1:12
        d(i) = dist_posture(Pm,squeeze(posturemode(:,i,:)));
    end
    [~,Idx] = min(d);
    Ymean(t) = Idx;
    Xmean(:,t,:) = posturemode(:,Idx,:);
end


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
exportgraphics(AX,'ModePlot12_Original_motion12.pdf','Resolution',300)

figure
imagesc(distSorted)
axis square
AX = gca;
exportgraphics(AX,'Sorted_Dist_Matrix_All_12.pdf','Resolution',300)