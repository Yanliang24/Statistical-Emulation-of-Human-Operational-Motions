function Results = evaluation(X, Xnew, tree, KernelVMF,posturemode)
    
    Results = zeros(1,11);

    %% Energy Distance
    Results(1) = EnergyDistance(X, Xnew);

    %% Cross_sectional variance    
    Results(2) = cross_sectional_variance(Xnew);

    %% Jerk Test
    Results(3) = Jerk_test(Xnew);
    
    %% Acceleration Test
    Results(4) = Acc_test(Xnew);
    
    %% Posture Validity   
    [Results(5), Results(6)] = Validity_Test(Xnew, KernelVMF, 0.05, tree);

    %% Quantization Varibility
    XM = mean_posture_seq(X);   
    Results(7) = quan_var(Xnew, posturemode, XM);

    %% KNN
    Results(8) = KNN_test_all(X, Xnew, 5);
    
    %% Nearest Neighbor Distance 
    Results(9) = ANND(X, Xnew);
    
    %% ANND of Max Posture Distance
    Results(10) = ANND_MP(X, Xnew);
    
    %% Roughness
    Results(11) = ANND_R(X, Xnew);
end
    
    
    
    
    
    
    


