%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANND_MP - The code is to compute average nearest neighbor distance of max posture distance between two datasets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D = ANND_MP(X0, X1)

n1 = size(X0,2);
n2 = size(X1,2);
for i = 1:n2
    for j = 1:n1
        dmj(j) = dist_seq_max_posture(X1{i},X0{j});
    end
    dm(i) = min(dmj);
end


D = mean(dm);
