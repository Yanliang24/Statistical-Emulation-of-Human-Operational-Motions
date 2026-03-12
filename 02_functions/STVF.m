%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STVF - The code is to generate STVF functions from posture sequences
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [T_V] = STVF(posture_seq)

    T = size(posture_seq, 2);
    X0=squeeze(posture_seq(:,1,:));
    for i = 1:T-1
        X1=squeeze(posture_seq(:,i,:));
        X2=squeeze(posture_seq(:,i+1,:));
        
        V = InverseExp_At_Posture(X1,X2);
        V_par=[];

        if i==1
            V_par = V;
        else
        V_par = ParallelTransport_Posture(X1, V, X0);
        end
        T_V(i,:,:) = V_par;
    end


end
