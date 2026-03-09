%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TangenF_Recon - The code is to reconstruct a SIEM function back to posture sequence
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Re_posture] = TangentF_Recon(TF, ref_posture)

T = size(TF, 1);

for i = 1:T
    V = squeeze(TF(i,:,:));
    P=Exp_At_Posture(ref_posture,V);    
    Re_posture(:,i,:) = P;
end


end
