clear
addpath ..\

load SimSeqFull_New_100_ITVF.mat XGM
XNew(1,:) = XGM(:,1:99);

load SimSeqFull_New_100_SIEM.mat XGM
XNew(2,:) = XGM(:,1:99);

load SimSeqFull_New_100_PWI.mat Xnew
XNew(3,:) = Xnew(:,1:99);

load SimSeqFull_New_100_VAR.mat Xnew
XNew(4,:) = Xnew(:,1:99);

load generated_motions_New_full_3.mat
for i = 1:99
    % X2 = squeeze(generated(i,:,:,:));
    X2 = generated{i};
    X2 = permute(X2,[2,1,3]);
    XNew{5,i} = X2;
end

load motion_sequences_new_3.mat
for i = 1:99
    X2 = squeeze(motion_data(i,:,:,:));
    X2 = permute(X2,[2,1,3]);
    XNew{6,i} = X2;
end

save('GenSeqFull_New.mat', "XNew")