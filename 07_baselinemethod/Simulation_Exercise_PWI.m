%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation_Exercise_PWI - The code is to simulate sequences
% using baseline model PWI descripbed in Sec. 6.2 using Exercise
% dataset
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear
addpath('../02_functions/')
addpath('../03_metrics/')

num_runs = 10;          % Number of Runs
num_sim = 100;          % NUmber of Simulation
rng(123456)             % Random Setting

for r = 1:num_runs
    Result = struct();
    Result.SimulatedData = cell(1, num_sim); % 5 subclasses
    Result.metrics = zeros(1, 11);      % 11 metrics
    
    %% === Load Exercise Dataset ===
    filename = sprintf('../01_data/MotionNew_Outcome_800.mat');   
    load(filename, 'X','tree') 
    M = size(X,2);
    [~,Ty,~] = size(X{1});
    
    %% === Step 1. Compute Cross-Sectional Mean and Variance ===
    for t = 1:Ty
        % Mean
        mpost = squeeze(X{1}(:,t,:));
        nIter = 25;
        for n = 1:nIter
            for m = 1:M
                X_mt = squeeze(X{m}(:, t, :)); 
                V(:,m,:) = InverseExp_At_Posture(mpost,X_mt);
            end
            mpost = Exp_At_Posture(mpost, squeeze(mean(V, 2)));
            lik(n) = sum(V(:).^2);
        end
        Mpos(:,t,:) = mpost;
        % Variance
        for m = 1:M
            X_mt = squeeze(X{m}(:, t, :)); 
            V(:,m,:) = InverseExp_At_Posture(mpost,X_mt);
        end
        for i = 1:20
            MPost(i,:,t) = mean(squeeze(V(i,:,:)));
            Cpost(i,:,:) = squeeze(V(i,:,:))'*squeeze(V(i,:,:))/(M-1);
        end
        Cpos{t} = Cpost;
    end
    
    %% === Step 2. Simulation ===
    for k = 1:num_sim
        for t = 1:Ty
            for i = 1:20               
                Ct = squeeze(Cpos{t}(i,:,:));
                try
                    V_new(i,:) = mvnrnd(MPost(i,:,t),Ct,1);
                catch 
                    [VV,D] = eig(Ct);  
                    Ct_new = VV*max(D,0)/VV;
                    V_new(i,:) = mvnrnd(MPost(i,:,t),Ct_new,1);
                end
            end
            X_new(:,t,:) = Exp_At_Posture(squeeze(Mpos(:,t,:)),V_new);
        end
        Xnew{k} = X_new;
    end
    Result.SimulatedData = Xnew;
    
    %% === Step 3. Evaluation ===
    load('../03_metrics/posture_modes_new_7.mat','posturemode')
    load('../03_metrics/Estimated_ROW_New.mat', 'KernelVMF')
    Result.metrics = evaluation(X, Xnew, tree, KernelVMF, posturemode);

    %% Save
    save_path = sprintf('../06_results/ExerciseData/PWI/run_%d.mat', r);
    save(save_path, 'Result');
end
