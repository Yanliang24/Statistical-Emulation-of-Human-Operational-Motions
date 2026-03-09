function [S, Integrity] = Validity_Test(X, KernelVMF, alpha, tree)
    I = length(X);
    for i = 1:I
        [Si(i), Inte(i)] = Validity_Score_ver4(X{i}, KernelVMF, alpha, tree);
    end
    S = mean(Si);
    Integrity = mean(Inte);
end