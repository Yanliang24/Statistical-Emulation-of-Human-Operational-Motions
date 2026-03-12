%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KNN_Classifier - The code is to perform knn classification of Xnew using X as training set 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [L] = KNN_Classifier(X, Xnew, Label, k)
    
N = length(X);
for i = 1:N
    L0(i) = dist_seq_to_seq(Xnew, X{i});
end

[~, inx] = mink(L0,k);
L = mode(Label(inx));


