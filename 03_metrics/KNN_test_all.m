%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KNN_test_all - The code is to perform knn clasification test on datasets X1 and X2
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Acc = KNN_test_all(X1, X2, k)
S1 = length(X1);
S2 = length(X2);
Xall = [X1 X2];
Label = [ones(1,S1), zeros(1,S2)];
I = 1:S1+S2;
for i = 1:S1+S2
    XN = Xall(:,I~=i,:);
    LN = Label(I~=i);   
    L(i) = KNN_Classifier(XN,Xall{i},LN, k);
end


Acc = sum(L==Label)/(S1+S2);
