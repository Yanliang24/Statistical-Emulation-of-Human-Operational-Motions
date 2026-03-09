%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TangentF - The code is to map posture sequence to a share tangent space by SIEM
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [T_F] = TangentF(posture_seq,posture_ref)

    T = size(posture_seq, 2);
    X0= posture_ref;
    for i = 1:T
        X1=squeeze(posture_seq(:,i,:));       
        V = InverseExp_At_Posture(X0,X1);
        T_F(i,:,:) = V;
    end

end
