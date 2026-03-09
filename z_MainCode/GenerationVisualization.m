clear
addpath('..\MotionCode\')
%% load data
load RWP_1_Outcome_300.mat Ref_pos_data tree
% load .\Generation\Generation\Full\GenSeqFull_ITVF_VAR.mat
load GenSeqFull_Motion2_LowDim_ITVF_FPCA.mat
load mean_sequence.mat XM


% % MDS plot
% I = randperm(100,60);
% X_combine = [Xc(1:60) X_New(I)];
% for i = 1:120
%     for j = 1:120
%         if i == j
%             d(i,j) = 0;
%         elseif i<j
%             d(i,j) = dist_seq_to_seq(X_combine{i},X_combine{j});
%         else
%             d(i,j) = d(j,i);
%         end
%     end
% end
% 
% MD = cmdscale(d,2);
% figure(100)
% plot(MD(1:60,1),MD(1:60,2),'r.','MarkerSize',10)
% hold on
% plot(MD(61:120,1),MD(61:120,2),'b.','MarkerSize',10)
% axis square
% ax = gca;
% exportgraphics(ax,'MDS_ITVF_VAR.eps','Resolution',300) 

% I = randperm(100,60);
% X_combine = [X(1:60) XnewE(I)];
% for i = 1:120
%     for j = 1:120
%         if i == j
%             d(i,j) = 0;
%         elseif i<j
%             d(i,j) = dist_seq_to_seq(X_combine{i},X_combine{j});
%         else
%             d(i,j) = d(j,i);
%         end
%     end
% end
% 
% MD = cmdscale(d,2);
% figure(200)
% plot(MD(1:60,1),MD(1:60,2),'r.','MarkerSize',10)
% hold on
% plot(MD(61:120,1),MD(61:120,2),'b.','MarkerSize',10)
% axis square
% ax = gca;
% exportgraphics(ax,'MDS_SIEM_FPCA_Nonparametric.eps','Resolution',300) 

%% Posture Sequence Plot
% N = 3;
% Iseq1 = randperm(100,N);
% 
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
% 
% for i = 1:N
%     XX = X_New{Iseq1(i)};   
%     filename = sprintf('ITVF_VAR_generation_%d.eps',i);
%     skeleton_data_new = posture_to_skeleton(XX, len1, tree);
%     figure(10+i)
%     DrawSkeletonSequenceAction_SKKU(skeleton_data_new,30,'r','k', 1, 0, '', 0:300);
%     set(gcf,'Position',[100 100 900 250])
%     ax = gca;
%     exportgraphics(ax,filename,'Resolution',300) 
% end

% Iseq2 = randperm(100,N);
% for i = 1:N
%     XX = XnewE{Iseq2(i)};
%     filename = sprintf('SIEM_FPCA_Nonparametric_generation_%d.eps',i);
%     skeleton_data_new = posture_to_skeleton(XX, len1, tree);
%     figure(20+i)
%     DrawSkeletonSequenceAction_SKKU(skeleton_data_new,30,'r','k', 1, 0, '', 0:300);
%     set(gcf,'Position',[100 100 900 250])
%     ax = gca;
%     exportgraphics(ax,filename,'Resolution',300) 
% end

%% Video
Nv = 5;
Iv1 = randperm(100,Nv);
for i = 1:Nv
    XXv1 = XnewG{Iv1(i)};

    % Compare to nearest sequence
    for j = 1:60
        ds1(j) = dist_seq_to_seq(X{j},XXv1);
    end

    [~,ing] = min(ds1);
    XX0 = X{ing};
    filename = sprintf('ITVF_Gaussian_Motion1(5x10)_Video_%d',i);
    CreateVideo(XX0,XXv1,len1,tree,filename,8);

    filename = sprintf('ITVF_Nonparametric_Motion1(5x10)_Mean_Video_%d',i);
    CreateVideo(XM{2},XXv1,len1,tree,filename,8);
end

Iv2 = randperm(100,Nv);
for i = 1:Nv
    XXv2 = XnewE{Iv2(i)};
    for j = 1:60
        ds2(j) = dist_seq_to_seq(X{j},XXv2);
    end

    [~,ine] = min(ds2);
    XX0 = X{ine};
    filename = sprintf('ITVF_Nonparametric_Motion2(5x10)_Video_%d',i);
    CreateVideo(XX0,XXv2,len1,tree,filename,8);

    filename = sprintf('ITVF_FPCA_Nonparametric_Motion2(5x10)_Mean_Video_%d',i);
    CreateVideo(XM{2},XXv2,len1,tree,filename,8);
end

