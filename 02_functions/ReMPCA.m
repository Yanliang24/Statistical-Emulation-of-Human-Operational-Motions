function [X] = ReMPCA(Z,Uf,Mean)

N=ndims(Z)-1;%Order of the tensor sample
Is=size(Z);%32x32x320
numSpl=Is(3);
X = ttm(tensor(Z),Uf,1:N,'t'); 
X = X+repmat(Mean,[ones(1,N), numSpl]);

