%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% skeleton_to_posture - The code converts skeleton data "skeleton_data"
% (1st input) to posture data by Equation (1) of the manuscript
%     
% tree: tree hierarchy of 21 landmarks (2 x 20): 20 pairs of parent and child node numbers  
%
% Reference: Anonymous
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- USAGE IN THIS STUDY ---
% This function is used to visulize motion sequences (Figure 5, 6, 11, and 12)
% in the paper: "Statistical Emulations of Human Operational Motions in Industrial Environments" (2026).
% No modifications have been made to the original logic.

% convert skeleton data to posture data given a tree hierachy 
function [posture_data, len] = skeleton_to_posture(skeleton_data, tree)
    posture_data = skeleton_data(tree(2,:), :, :) - skeleton_data(tree(1,:), :, :);
    len = mean(sqrt(sum(posture_data.^2, 3)), 2); 
    posture_data = posture_data./repmat(sqrt(sum(posture_data.^2, 3)), [1,1,3]);
end