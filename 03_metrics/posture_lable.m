function [Y, D] = posture_lable(X,posturemode)

[~, MaxI,~] = size(posturemode);
for i = 1:MaxI
    dt(i) = dist_posture(X,squeeze(posturemode(:,i,:)));
end
[~,Idx] = min(dt);

Y = Idx;
D = dt;