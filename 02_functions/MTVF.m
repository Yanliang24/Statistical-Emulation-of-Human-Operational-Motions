%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MTVF - The code is to generate the MTVF functions from posture sequences
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [T_V] = MTVF(posture_seq)

    T = size(posture_seq, 2);

    for i = 1:T-1
        X1=squeeze(posture_seq(:,i,:));
        X2=squeeze(posture_seq(:,i+1,:));
        
        V = InverseExp_At_Posture(X1,X2);
        V_par=[];

        if i==1
            V_par = V;
        else
            for j = i:-1:2
                Z1 = squeeze(posture_seq(:,j-1,:));
                Z2 = squeeze(posture_seq(:,j,:));
                V_par = ParallelTransport_Posture(Z2, V, Z1);
            end
        end
        T_V(i,:,:) = V_par;
    end


end

