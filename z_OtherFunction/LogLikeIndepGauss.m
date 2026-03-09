function [L] = LogLikeIndepGauss(S,Vf)

[M,D2,D1] = size(S);
L = zeros(1,M);
for i = 1:M
    LR = 0;
    for k = 1:D1
        s = S(i,:,k);
        lr = sum(log(normpdf(s,zeros(1,D2),Vf(k,:))));
        LR = LR+lr;
    end
    L(i) = LR;
end