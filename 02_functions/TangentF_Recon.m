%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TangenF_Recon - The code is to reconstruct a SIEM function back to posture sequence
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
