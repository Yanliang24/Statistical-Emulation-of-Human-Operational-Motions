function A = Acceleration(posture_seq)

    [N, T, D] = size(posture_seq);
    X0=squeeze(posture_seq(:,1,:));
    TV = zeros(T-1,N,D);
    for i = 1:T-1
        X1=squeeze(posture_seq(:,i,:));
        X2=squeeze(posture_seq(:,i+1,:));
        
        V = InverseExp_At_Posture(X1,X2);
        V_par=[];

        if i==1
            V_par = V;
        else
        V_par = ParallelTransport_Posture_1(X1, V, X0);
        end
        TV(i,:,:) = V_par;
    end
    A = zeros(T-3,N,D);
    for i = 1:T-2
        A(i,:,:) = TV(i+1,:,:) - TV(i,:,:);
    end
end
