%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- SOURCE & ATTRIBUTION ---
% Original Author: Park, C.
% Provided by: Park, C.
% 
% Reference:Park, C., Noh, S.D. and Srivastava, A.
%           Data science for motion and time analysis with modern motion sensor data. 
%           Operations Research. 
%
% --- USAGE IN THIS STUDY ---
% This function is slightly modified for formatting and used to visulize motion sequences (Figure 5, 6, 11, and 12)
% in the paper: "Statistical Emulations of Human Operational Motions in Industrial Environments" (2026).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h=DrawSkeletonSequenceAction(skeleton_bis,k,Ec,Lc,fs,varargin)
    %skeleton_bis contains the skeleton
    if nargin > 5,
        ss = varargin{1};
    else
        ss = 1;
    end
    
    if nargin > 6
        zoffset = varargin{2};
    else
        zoffset = 0;
    end
    %k is the step
    
    %a=[1     1     2     5     3    6     16    17    18     19     20     21    17   8     9    10    17    12    13   14];
    %b=[2     5     3     6     4    7     17    18    19     20     21     1     8    9    10    11    12    13    14   15];
    a=[21  21  1   1   20  2   3   5   6   19  18  17 17   17  8   9   10  12  13  14];
    b=[1   20	2   5   19  3   4   6   7   18  17  8  12   16  9   10  11  13  14  15];
  

    [n,m,t]=size(skeleton_bis);   %m - the frame #, n - the joint number, k - the 3D coordinates 
    
    hh = max(max(squeeze(skeleton_bis(1:n,:,3)))) +0.2;
    
    cnt = 0;
    for i=1:k:m
        %clf
        cnt = cnt + 1;
        stepp = ss*(i-1)/k; 
        plot3(skeleton_bis(1:n,i,1)+stepp,skeleton_bis(1:n,i,2),skeleton_bis(1:n,i,3)+zoffset ,'.','MarkerSize',30,'MarkerFaceColor',Lc,'MarkerEdgeColor',Lc);
        hold on
        c = mean(skeleton_bis(1:n,i,1)+stepp);
        %text(c, 0, 1, strcat('t=',num2str(cnt)));
        for j=1:length(a)
            line([skeleton_bis(a(j),i,1)+stepp skeleton_bis(b(j),i,1)+stepp],[skeleton_bis(a(j),i,2) skeleton_bis(b(j),i,2)],[skeleton_bis(a(j),i,3) skeleton_bis(b(j),i ,3)]+zoffset,'Color',Ec,'LineWidth',3);
            axis equal
            axis off
            hold on,
          %  view([-182 -82])
            view([-29 0])
        end
        
        if nargin > 8,
            lbl = varargin{4};
            lbl = strcat('$$\tilde{t}$$=',sprintf('%3d', lbl(i)));
            text(mean(squeeze(skeleton_bis(1:n,i,1)))-0.2+stepp, mean(squeeze(skeleton_bis(1:n,i,2))), hh+zoffset, lbl,'FontSize',14, 'Interpreter','latex');
        end
        pause(0.01);
    end

    if nargin > 7
        lbl = varargin{3};
        text(mean(squeeze(skeleton_bis(1:n,1,1)))-1.6, mean(squeeze(skeleton_bis(1:n,1,2))), mean(squeeze(skeleton_bis(1:n,1,3)))+zoffset, lbl,'FontSize',fs);
    end
end

