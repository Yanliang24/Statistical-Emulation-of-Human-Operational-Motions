%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% skeleton_to_posture - The code converts posture data "posture_data" (1st input of this function)
%                         back to the skeleton data "skeleton_data" (the output),
%                         using the inverse of Equation (1) of the manuscript
%                
% len: lengths of body part sizes
% tree: tree hierarchy of 21 landmarks (2 x 20): 20 pairs of parent and child node numbers  
% 
% Reference: Anonymous
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- USAGE IN THIS STUDY ---
% This function is slightly modified to adapt the Exercise dataset and used to visulize motion sequences (Figure 5, 6, 11, and 12)
% in the paper: "Statistical Emulations of Human Operational Motions in Industrial Environments" (2026).

function [skeleton_data] = posture_to_skeleton_new(posture_data, len, tree)
    
    [~, idx] = sort(tree(2, :));
    [n, m, k] = size(posture_data);
    posture_data = reshape(posture_data, n, []);
    posture_data = diag(len) * posture_data;
    posture_data = posture_data(idx, :, :);
    
    current = min(tree(:));
    loc     = zeros(1, m*k);
    data    = [current loc; add_children(posture_data, len, tree, current, loc)];
    [~, idx] = sort(data(:, 1));
    skeleton_data = reshape(data(idx, 2:end), n+1, m, k);

    function [skeleton_data] = add_children(posture_data, len, tree, current, loc)
        id = tree(1, :) == current;
        children = tree(2, id);
        
        skeleton_data = [];
        for i = 1:length(children)
            child_loc = loc + posture_data(children(i)-1, :); 
            skeleton_data = [skeleton_data; children(i) child_loc];
            skeleton_data = [skeleton_data; add_children(posture_data, len, tree, children(i), child_loc)]; 
        end
    end
end
