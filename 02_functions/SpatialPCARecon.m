%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SpatialPCARecon - The code is to reconstruct Spatial PCA result back to IS-TVF or SIEM functions
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C] = SpatialPCARecon(Z,Ud,Mu)
    [N,M,D1] = size(Z);
    for i = 1:M  
        Ct = reshape(Z(:, i, :), [N, D1])*Ud(:,1:D1)' + Mu;
        C(:,i,:) = Ct;
    end
end

