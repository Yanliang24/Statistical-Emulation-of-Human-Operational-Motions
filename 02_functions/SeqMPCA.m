function [Z,Mean,Uf] = SeqMPCA(X,testQ)

X = permute(X,[3,1,2]);
N=ndims(X)-1;%Order of the tensor sample
Is=size(X);%32x32x320
numSpl=Is(3);
[tUs, odrIdx, TXmean, Wgt] = MPCA(X,1,testQ,1); %MPCA
Ctr = X-repmat(TXmean,[ones(1,N), numSpl]); %Centering
Z = ttm(tensor(Ctr),tUs,1:N); %NewFeature;
Z = double(Z);
Mean = TXmean;
Uf = tUs;
