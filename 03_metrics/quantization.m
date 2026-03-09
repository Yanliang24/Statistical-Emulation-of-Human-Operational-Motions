function [Y] = quantization(X, posturemode)

[~,T,~] = size(X);
for t = 1:T
    Idx = posture_lable(squeeze(X(:,t,:)), posturemode);
    Y(t) = Idx;
end
