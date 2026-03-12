%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ISTVF_to_posture - The code is to map ISTVF functions back to posture space
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X,Y,Cm] = ISTVF_to_posture(CIS,V_ref,W_ref,mpos)
    [Ty,Rn,~] = size(CIS);
    for i = 1:Rn
        %coeffiecnt
        CISt = squeeze(CIS(:,i,:));
        Cmt= [CISt(1,:); diff(CISt)];
        Cm(:,i,:) = Cmt;
        Cmt = reshape(Cmt,[Ty,20,2]);
        for t = 1:Ty
            Yt(t,:,:) = V_ref.*squeeze(Cmt(t,:,1))' + W_ref.*squeeze(Cmt(t,:,2))';    
        end
        posture_re = STVF_Recon(Yt, mpos);
        Y{i} = Yt;
        X{i} = posture_re;
    end

end

