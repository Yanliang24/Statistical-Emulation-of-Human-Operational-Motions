%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trainVAE - The code is to train VAE for spatial dimension reduction
% 
% This script is part of the reproducibility package for the paper:
% Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human
% Operational Motions in Industrial Environments
%
% Copyright ©2026 Yanliang Chen
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function model = trainVAE(XData, opts)

% INPUTS:
%   XData : [N x D] matrix (N samples, D features)
%   opts  : struct with optional fields:
%       latentDim   - dimension of latent space (default 10)
%       hiddenDim   - hidden layer width (default 64)
%       numEpochs   - number of training epochs (default 500)
%       learnRate   - learning rate (default 1e-3)
%       batchSize   - mini-batch size (default 128)
%       beta        - KL weight (default 0.001)
%       savePath    - file path to save model (default 'vae_model.mat')
%
% OUTPUT:
%   model : struct with encoder, decoder, and helper functions.
%
% EXAMPLE USAGE:
%   % Create toy data (1000 samples, 20 features)
%   X = randn(1000,20);
%   opts = struct('latentDim',5,'numEpochs',50,'savePath','vae_model.mat');
%   model = trainVAE(X, opts);
%
%   % Encode some samples into latent space
%   Z = model.encode(X(1:10,:));
%   % Decode latent codes back into input space
%   Xhat = model.decode(Z);
%   % Or directly reconstruct
%   Xrec = model.reconstruct(X(1:10,:));

% Defaults
if nargin < 2, opts = struct; end
opts = setfieldifmissing(opts, 'latentDim', 10);
opts = setfieldifmissing(opts, 'hiddenDim', 64);
opts = setfieldifmissing(opts, 'numEpochs', 500);
opts = setfieldifmissing(opts, 'learnRate', 1e-3);
opts = setfieldifmissing(opts, 'batchSize', 128);
opts = setfieldifmissing(opts, 'beta', 0.001);

latentDim = opts.latentDim;
inputDim = size(XData,2);

% Encoder
encoderLG = layerGraph([
    featureInputLayer(inputDim,'Normalization','none','Name','input')
    fullyConnectedLayer(opts.hiddenDim,'Name','fc1')
    tanhLayer('Name','tanh1')
]);
muLayer = fullyConnectedLayer(latentDim,'Name','mu');
logVarLayer = fullyConnectedLayer(latentDim,'Name','logvar');
encoderLG = addLayers(encoderLG, muLayer);
encoderLG = addLayers(encoderLG, logVarLayer);
encoderLG = connectLayers(encoderLG, 'tanh1', 'mu');
encoderLG = connectLayers(encoderLG, 'tanh1', 'logvar');

% Decoder
decoderLG = layerGraph([
    featureInputLayer(latentDim,'Normalization','none','Name','z')
    fullyConnectedLayer(opts.hiddenDim,'Name','fc2')
    tanhLayer('Name','tanh2')
    fullyConnectedLayer(inputDim,'Name','reconstruction')
]);

% Networks
encoderNet = dlnetwork(encoderLG);
decoderNet = dlnetwork(decoderLG);

% Training setup
ads = arrayDatastore(XData, 'IterationDimension', 1);
mbq = minibatchqueue(ads, ...
    'MiniBatchSize', opts.batchSize, ...
    'MiniBatchFormat','CB', ...
    'MiniBatchFcn', @(x) dlarray(cell2mat(x)', 'CB'));

trailingAvgE = [];
trailingAvgSqE = [];
trailingAvgD = [];
trailingAvgSqD = [];

% Training loop
for epoch = 1:opts.numEpochs
    reset(mbq);
    while hasdata(mbq)
        X = next(mbq);
        [loss, gradE, gradD] = dlfeval(@modelGradients, encoderNet, decoderNet, X, opts.beta);
        [encoderNet, trailingAvgE, trailingAvgSqE] = adamupdate(encoderNet, gradE, ...
            trailingAvgE, trailingAvgSqE, epoch, opts.learnRate);
        [decoderNet, trailingAvgD, trailingAvgSqD] = adamupdate(decoderNet, gradD, ...
            trailingAvgD, trailingAvgSqD, epoch, opts.learnRate);
    end
    fprintf('Epoch %d, Loss = %.4f\n', epoch, double(loss));
end

% Build model struct
model.encoderNet = encoderNet;
model.decoderNet = decoderNet;
model.latentDim  = latentDim;
model.inputDim   = inputDim;
model.opts       = opts;
model.encode     = @(X) encode(encoderNet,X);
model.decode     = @(Z) decode(decoderNet,Z);
model.reconstruct= @(X) reconstruct(encoderNet,decoderNet,X);

end

%% -------- Helpers --------
function [loss, gradientsEncoder, gradientsDecoder] = modelGradients(encoderNet, decoderNet, x, beta)
    mu = forward(encoderNet, x,'Outputs','mu');
    logVar = forward(encoderNet, x,'Outputs','logvar');
    z = sampling(mu, logVar);
    xPred = forward(decoderNet, z);
    reconLoss = mse(xPred, x);
    klLoss = -0.5 * sum(1 + logVar - mu.^2 - exp(logVar), 'all') / size(x, 2);
    loss = reconLoss + beta * klLoss;
    gradientsEncoder = dlgradient(loss, encoderNet.Learnables);
    gradientsDecoder = dlgradient(loss, decoderNet.Learnables);
end

function z = sampling(mu, logVar)
    eps = randn(size(mu), 'like', mu);
    sigma = exp(0.5 * logVar);
    z = mu + sigma .* eps;
end

function Z = encode(encoderNet,X)
    dlX = dlarray(X','CB');
    mu = forward(encoderNet,dlX,'Outputs','mu');
    Z = extractdata(mu)';
end

function XRecon = decode(decoderNet,Z)
    dlZ = dlarray(Z','CB');
    dlXRecon = forward(decoderNet,dlZ);
    XRecon = extractdata(dlXRecon)';
end

function XRecon = reconstruct(encoderNet,decoderNet,X)
    dlX = dlarray(X','CB');
    mu = forward(encoderNet,dlX,'Outputs','mu');
    dlXRecon = forward(decoderNet,mu);
    XRecon = extractdata(dlXRecon)';
end

function opts = setfieldifmissing(opts,field,val)
    if ~isfield(opts,field) || isempty(opts.(field))
        opts.(field) = val;
    end
end

