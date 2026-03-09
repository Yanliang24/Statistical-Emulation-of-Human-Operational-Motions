function h=DrawSkeletonSequenceAction_label_new(skeleton_bis,k,Ec,Lc,fs,varargin)
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
    
    a = [1 1 1 2 3 3 3 4 6 7 8 10 11 12 14 15 16 18 19 20];
    b = [2 14 18 3 4 6 10 5 7 8 9 11 12 13 15 16 17 19 20 21];
  

    [n,m,t]=size(skeleton_bis);   %m - the frame #, n - the joint number, k - the 3D coordinates 
    
    hh = max(max(squeeze(skeleton_bis(1:n,:,3))))+0.2;
    cnt = 0;
    for i=1:k:m
        %clf
        cnt = cnt + 1;
        stepp = ss*(i-1)/k; 
        plot3(skeleton_bis(1:n,i,1)+stepp,skeleton_bis(1:n,i,2),skeleton_bis(1:n,i,3)+zoffset ,'.','MarkerSize',20,'MarkerFaceColor',Lc,'MarkerEdgeColor',Lc);
        hold on
        c = mean(skeleton_bis(1:n,i,1)+stepp);

        %text(c, 0, 1, strcat('t=',num2str(cnt)));
        for j=1:length(a)
            line([skeleton_bis(a(j),i,1)+stepp skeleton_bis(b(j),i,1)+stepp],[skeleton_bis(a(j),i,2) skeleton_bis(b(j),i,2)],[skeleton_bis(a(j),i,3) skeleton_bis(b(j),i ,3)]+zoffset,'Color',Ec,'LineWidth',2);
            axis equal
            axis off
            hold on,
          %  view([-182 -82])
            % view([-29 0])
            view([0 0])
        end
        % pause

        if nargin > 8,
            lbl = varargin{4};
            lbl = strcat('$$\tilde{t}$$=',sprintf('%3d', lbl(i)));
            text(mean(squeeze(skeleton_bis(1:n,i,1)))-0.2+stepp, mean(squeeze(skeleton_bis(1:n,i,2))), hh+zoffset, lbl, 'FontSize',fs,'Interpreter','latex');
        end
        pause(0.01);
    end

    if nargin > 7
        lbl = varargin{3};
        text(mean(squeeze(skeleton_bis(1:n,1,1)))-2.5, mean(squeeze(skeleton_bis(1:n,1,2))), mean(squeeze(skeleton_bis(1:n,1,3)))+zoffset, lbl,'FontSize',fs);
    end
end

