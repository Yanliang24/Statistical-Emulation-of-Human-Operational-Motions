%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- SOURCE & ATTRIBUTION ---
% Original Author: Anonymous
% Provided by: Anonymous
%
% --- USAGE IN THIS STUDY ---
% This function is slightly modified for formatting and used to visulize motion sequences 
% in the paper.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h=DrawSkeleton_New(skeleton,tree,Ec,Lc)
    % tree(1,:) = [1 1 1 2 3 3 3 4 6 7 8 10 11 12 14 15 16 18 19 20];
    % tree(2,:) = [2 14 18 3 4 6 10 5 7 8 9 11 12 13 15 16 17 19 20 21];
    a = tree(1,:);
    b = tree(2,:);

    [n,k]=size(skeleton);   %m - the frame #, n - the joint number, k - the 3D coordinates 

    hh = max(max(skeleton(1:n,3)));

    plot3(skeleton(1:n,1),skeleton(1:n,2),skeleton(1:n,3) ,'.','MarkerSize',30,'MarkerFaceColor',Lc,'MarkerEdgeColor',Lc);
    hold on
    c = mean(skeleton(1:n,1));
    %text(c, 0, 1, strcat('t=',num2str(cnt)));
    for j=1:length(a)
        line([skeleton(a(j),1) skeleton(b(j),1)],[skeleton(a(j),2) skeleton(b(j),2)],[skeleton(a(j),3) skeleton(b(j),3)],'Color',Ec,'LineWidth',3);
        axis equal
        axis off
        hold on,
        % view([-182 -82])
        % view([-29 0])
    end
    view([-180 -80])
end
