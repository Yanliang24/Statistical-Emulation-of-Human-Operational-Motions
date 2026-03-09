%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIEM_to_posture - The code is to map SIEM functions back to posture space
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X,Y] = SIEM_to_posture(C,V_ref,W_ref,Ref_posture)
    [Ty,Rn,~] = size(C);
    for i = 1:Rn
        %coeffiecnt
        Ct = squeeze(C(:,i,:));
        Ct = reshape(Ct,[Ty,20,2]);
        for t = 1:Ty
            Yt(t,:,:) = V_ref.*squeeze(Ct(t,:,1))' + W_ref.*squeeze(Ct(t,:,2))';    
        end
        posture_re_new = TangentF_Recon(Yt, Ref_posture);
        Y{i} = Yt;
        X{i} = posture_re_new;
    end

end
