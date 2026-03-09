function [S] = Jerk_test(X)

I = length(X);
for i = 1:I
    J{i} = Jerk(X{i});
    Si(i) = Jerk_norm(J{i});
end
S = mean(Si(Si<100));