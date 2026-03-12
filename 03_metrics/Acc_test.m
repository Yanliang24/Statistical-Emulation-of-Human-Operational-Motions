%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acc_test - The code is to compute acceleration energy of dataset X
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S] = Acc_test(X)

I = length(X);
for i = 1:I
    A{i} = Acceleration(X{i});
    Si(i) = Acc_norm(A{i});
end

S = mean(Si);
