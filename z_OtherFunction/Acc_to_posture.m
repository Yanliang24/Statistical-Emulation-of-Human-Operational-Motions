function [X,Y,Cm] = Acc_to_posture(Ca,V_ref,W_ref,mpos)
    M = size(Ca, 2);
    for i = 1:M
        %coeffiecnt
        Cat = squeeze(Ca(:,i,:));
        Cmt= cumsum(Cat);
        Cm(:,i,:) = Cmt;
        Cmt = reshape(Cmt,[Ty,20,2]);
        for t = 1:Ty
            Yt(t,:,:) = V_ref.*squeeze(Cmt(t,:,1))' + W_ref.*squeeze(Cmt(t,:,2))';    
        end
        posture_re = TVF_Recon(Yt, mpos);
        Y{i} = Yt;
        X{i} = posture_re;
    end
end