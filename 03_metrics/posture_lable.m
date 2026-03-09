%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% posture_label - The code is to assign quantization lables to the posture data using the pre-trained cluster results
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
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
