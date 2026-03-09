%clear all

addpath('../MotionCode/')
addpath('../02_Functions/')
addpath('../03_Metrics/')
num_runs = 10;
num_sim = 100;
%Random Setting
rng(123456)

for r = 1:num_runs
    Result = struct();
    Result.SimulatedData = cell(5, num_sim); % 5 subclasses
    Result.metrics = zeros(5, 11);      % 11 metrics
    for s = 1:5
        %% Load data
        filename = sprintf('../01_Data/RWP_%d_Outcome_300.mat', s);   
        load(filename, 'aligned','tree')
        X = aligned;   
        M = size(X,2);
        [~,Ty,~] = size(X{1});

        [CIS,V_ref,W_ref,mpos,Xc,Yc] = FormISTVF(X);
    
        %% Spatial PCA
        D1 = 10;
        [ZZ,MuZ,UdZ,SigZ] = SpatialPCA(CIS,D1);
        
        %% Training
        Z1 = squeeze(ZZ(:,1,:));
        ZTrain = Z1;
        [Ty,~,~] = size(CIS);
        
        Mdl = varm(D1,4);
        EstMdl = estimate(Mdl,ZTrain);
        S = summarize(EstMdl);
        
        %% Simulation    
        % Simulate spatial PCA coefficient
        for i = 1:num_sim
            Znew(:,:,i) = simulate(EstMdl,Ty);
        end
        
        % Sequence construction
        for i = 1:num_sim
            CInew = Znew(:,:,i)*UdZ(:,1:D1)' + MuZ;
            Cnew = [CInew(1,:); diff(CInew)];
            CmNew(:,i,:) = Cnew;
            Cnew = reshape(Cnew,[Ty,20,2]);
            C_new = reshape(Cnew,[Ty,20,2]);
            for t = 1:Ty
                Y_new(t,:,:) = V_ref.*squeeze(C_new(t,:,1))' + W_ref.*squeeze(C_new(t,:,2))';    
            end
            Y_New{i} = Y_new;
            posture_new = STVF_Recon(Y_new, mpos);
            Xnew{i} = posture_new;
        end

        Result.SimulatedData(s,:) = Xnew;
        
        %% Evaluation
        load('../04_Models/posture_modes_12.mat','posturemode')
        load('../04_Models/Estimated_ROW.mat', 'KernelVMF')

        Result.metrics(s,:) = evaluation(X, Xnew, tree, KernelVMF,posturemode);
    end

    save_path = sprintf('../06_Result/WorkerData/VAR/run_%d.mat', r);
    save(save_path, 'Result');
end
