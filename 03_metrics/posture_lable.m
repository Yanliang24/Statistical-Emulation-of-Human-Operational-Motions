%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% posture_label - The code is to assign quantization lables to the posture data using the pre-trained cluster results
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Y, D] = posture_lable(X,posturemode)

[~, MaxI,~] = size(posturemode);
for i = 1:MaxI
    dt(i) = dist_posture(X,squeeze(posturemode(:,i,:)));
end
[~,Idx] = min(dt);

Y = Idx;

D = dt;
