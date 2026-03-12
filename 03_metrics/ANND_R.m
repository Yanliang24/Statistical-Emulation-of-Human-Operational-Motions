%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANND_R - The code is to compute average nearest neighbor distance of roughness distance between two datasets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [D, Dmin, DD]= ANND_R(X0, X1)

n1 = size(X0,2);
n2 = size(X1,2);
for i = 1:n1
    R0(i,:) = roughness(X0{i});
end

for i = 1:n2
    R1(i,:) = roughness(X1{i});
end

for i = 1:n2
    for j = 1:n1
        dr(i,j) = norm(R1(i,:) - R0(j,:));
    end
end

D = mean(min(dr,[],2));
Dmin = min(dr,[],2);

DD = dr;
