function h=DrawSkeletonSequenceAction_SKKU_2Colors(skeleton_bis1,skeleton_bis2,k,Ec1,Lc1,Ec2,Lc2,varargin)
    %skeleton_bis contains the skeleton
    if nargin > 7,
        ss = varargin{1};
    else
        ss = 1;
    end
    
    if nargin > 8
        zoffset = varargin{2};
    else
        zoffset = 0;
    end
    %k is the step
    
    %a=[1     1     2     5     3    6     16    17    18     19     20     21    17   8     9    10    17    12    13   14];
    %b=[2     5     3     6     4    7     17    18    19     20     21     1     8    9    10    11    12    13    14   15];
    a=[21  21  1   1   20  2   3   5   6   19  18  17 17   17  8   9   10  12  13  14];
    b=[1   20	2   5   19  3   4   6   7   18  17  8  12   16  9   10  11  13  14  15];
  

    [n1,m1,t1]=size(skeleton_bis1);   %m - the frame #, n - the joint number, k - the 3D coordinates 
    [n2,m2,t2]=size(skeleton_bis2);

    hh = max(max(squeeze(skeleton_bis1(1:n1,:,3)))) +0.2;
    
    cnt = 0;
    for i=1:k:m1
        %clf
        cnt = cnt + 1;
        stepp = ss*(i-1)/k; 
        plot3(skeleton_bis1(1:n1,i,1)+stepp,skeleton_bis1(1:n1,i,2),skeleton_bis1(1:n1,i,3)+zoffset ,'.','MarkerSize',30,'MarkerFaceColor',Lc1,'MarkerEdgeColor',Lc1);
        hold on
        c = mean(skeleton_bis1(1:n2,i,1)+stepp);
        %text(c, 0, 1, strcat('t=',num2str(cnt)));
        for j=1:length(a)
            line([skeleton_bis1(a(j),i,1)+stepp skeleton_bis1(b(j),i,1)+stepp],[skeleton_bis1(a(j),i,2) skeleton_bis1(b(j),i,2)],[skeleton_bis1(a(j),i,3) skeleton_bis1(b(j),i ,3)]+zoffset,'Color',Ec1,'LineWidth',3);
            axis equal
            axis off
            hold on,
          %  view([-182 -82])
            view([-29 0])
        end
        
        if nargin > 10,
            lbl = varargin{4};
            lbl = strcat('$$\tilde{t}$$=',sprintf('%3d', lbl(i)));
            text(mean(squeeze(skeleton_bis1(1:n1,i,1)))-0.2+stepp, mean(squeeze(skeleton_bis1(1:n1,i,2))), hh+zoffset, lbl, 'Interpreter','latex');
        end
        pause(0.01);
    end
    
    for i=1:k:m2
        %clf
        cnt = cnt + 1;
        stepp = ss*(i+m1-1)/k; 
        plot3(skeleton_bis2(1:n2,i,1)+stepp,skeleton_bis2(1:n2,i,2),skeleton_bis2(1:n2,i,3)+zoffset ,'.','MarkerSize',30,'MarkerFaceColor',Lc2,'MarkerEdgeColor',Lc2);
        hold on
        c = mean(skeleton_bis2(1:n2,i,1)+stepp);
        %text(c, 0, 1, strcat('t=',num2str(cnt)));
        for j=1:length(a)
            line([skeleton_bis2(a(j),i,1)+stepp skeleton_bis2(b(j),i,1)+stepp],[skeleton_bis2(a(j),i,2) skeleton_bis2(b(j),i,2)],[skeleton_bis2(a(j),i,3) skeleton_bis2(b(j),i ,3)]+zoffset,'Color',Ec2,'LineWidth',3);
            axis equal
            axis off
            hold on,
          %  view([-182 -82])
            view([-29 0])
        end
        
        if nargin > 10,
            lbl = varargin{4};
            lbl = strcat('$$\tilde{t}$$=',sprintf('%3d', lbl(i+m1)));
            text(mean(squeeze(skeleton_bis2(1:n2,i,1)))-0.2+stepp, mean(squeeze(skeleton_bis2(1:n2,i,2))), hh+zoffset, lbl, 'Interpreter','latex');
        end
        pause(0.01);
    end

    if nargin > 9
        lbl = varargin{3};
        text(mean(squeeze(skeleton_bis2(1:n2,1,1)))-1.6, mean(squeeze(skeleton_bis2(1:n2,1,2))), mean(squeeze(skeleton_bis2(1:n2,1,3)))+zoffset, lbl);
    end
end