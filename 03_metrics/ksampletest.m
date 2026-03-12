%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ksampletest - The code is to two-sample test using distance matrix D
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,T,T0] = ksampletest(D,Na,Nb,MaxItr)

    T0 = (2*sum(D(1:Na,Na+1:Na+Nb),"all")/(Na*Nb)-sum(D(1:Na,1:Na),"all")/(Na*Na)-sum(D(Na+1:Na+Nb,Na+1:Na+Nb),"all")/(Nb*Nb)); 
    
    T = [];
    % rng(123456)
    for i = 1:MaxItr
        I = randperm(Na+Nb);
        d = D(I,I);
        T(i) = (2*sum(d(1:Na,Na+1:Na+Nb),"all")/(Na*Nb)-sum(d(1:Na,1:Na),"all")/(Na*Na)-sum(d(Na+1:Na+Nb,Na+1:Na+Nb),"all")/(Nb*Nb)); 
    end
    

    p = sum(T>T0)/MaxItr;
