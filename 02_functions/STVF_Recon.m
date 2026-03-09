%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STVF_Recon - The code is to reconstruct STVF functions back to posture space
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Re_posture] = STVF_Recon(Transport_V, posture_0)

T = size(Transport_V, 1)+1;

Re_posture(:,1,:)=posture_0;
    for i = 2:T
        V = squeeze(Transport_V(i-1,:,:));
        if i==2
            P=Exp_At_Posture(posture_0,V);
            Re_posture(:,i,:)=P;
        else
            Y2=squeeze(Re_posture(:,i-1,:));
            V_par = ParallelTransport_Posture(posture_0, V, Y2);
            P = Exp_At_Posture(Y2,V_par);
        end
        Re_posture(:,i,:) = P;
    end


end
