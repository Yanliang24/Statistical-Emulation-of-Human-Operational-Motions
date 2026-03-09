function [C] = SPCAReconstruction(Z,Ud,Mu)
[~,M,D1] = size(Z);
    for i = 1:M  
        Ct = squeeze(Z(:,i,:))*Ud(:,1:D1)' + Mu;
        C(:,i,:) = Ct;
    end
end
