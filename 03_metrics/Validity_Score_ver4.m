%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Validity_Score_ver4 - The code is to compute posture validity score and integrity rate
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Sequence_S, Integrity, Posture_S] = Validity_Score_ver4(X, F, alpha, tree)

if ndims(X) == 3
    T = size(X,2);
elseif ndim(X) == 2
    T = 1;
end

if tree(1,1) == 1
    I = 10;
    Test_Id(1,:) =  [5  8];             % Neck
    Test_Id(2,:) =  [7  12];            % Right Shoulder
    Test_Id(3,:) =  [6  9];             % Left Shoulder
    Test_Id(4,:) =  [12 13];            % Right Elbow
    Test_Id(5,:) =  [9  10];            % Left Elbow
    Test_Id(6,:) =  [3  18];            % Right Hip
    Test_Id(7,:) =  [2  15];            % Left Hip
    Test_Id(8,:) =  [18 19];            % Right Knee
    Test_Id(9,:) =  [15 16];            % Left Knee 
    Test_Id(10,:) = [4  5];             % Spine
elseif tree(1,1) == 21
    I = 9;                              % No Spine
    Test_Id(1,:) =  [11 14];            % Neck
    Test_Id(2,:) =  [12 15];            % Right Shoulder
    Test_Id(3,:) =  [13 18];            % Left Shoulder
    Test_Id(4,:) =  [18 19];            % Right Elbow
    Test_Id(5,:) =  [15 16];            % Left Elbow
    Test_Id(6,:) =  [3  6];             % Right Hip
    Test_Id(7,:) =  [4  8];             % Left Hip
    Test_Id(8,:) =  [6  7];             % Right Knee
    Test_Id(9,:) =  [8  9];             % Left Knee 
end

for i = 1:I
    for t = 1:T
        Xt = get_coordinate(squeeze(X(Test_Id(i,1),t,:))',squeeze(X(Test_Id(i,2),t,:))');
         % Evaluate KDE
        f_test = spherical_kde(F(i).Z, F(i).kappa, Xt);
        S(t,i) = f_test >= F(i).t_alpha;
    end   
end

Posture_S = mean(S,2);
Sequence_S = mean(Posture_S);
Integrity = sum(Posture_S==1)/T;
