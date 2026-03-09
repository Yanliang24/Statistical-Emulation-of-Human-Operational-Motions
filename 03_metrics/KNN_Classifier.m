%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KNN_Classifier - The code is to perform knn classification of Xnew using X as training set 
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [L] = KNN_Classifier(X, Xnew, Label, k)
    
N = length(X);
for i = 1:N
    L0(i) = dist_seq_to_seq(Xnew, X{i});
end

[~, inx] = mink(L0,k);
L = mode(Label(inx));


