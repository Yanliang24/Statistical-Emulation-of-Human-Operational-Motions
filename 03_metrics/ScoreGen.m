%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ScoreGen - The code is to compute coefficents using pre-trained PCA model
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S,Z] = ScoreGen(C,Uf,Mf,Ud,Mu)

[Ty,M,~] = size(C);
[~,D1] = size(Ud);
[~,D2,~] = size(Uf);
Z = zeros(Ty,M,D1);
S = zeros(M,D2,D1);
for i = 1:M
    Z(:,i,:) = (squeeze((C(:,i,:)))-Mu)*Ud;
    for k = 1:D1    
        TS = Uf(:,:,k)'*(Z(:,i,k)-Mf(k,:)');
        S(i,:,k) = TS;
    end 
end
