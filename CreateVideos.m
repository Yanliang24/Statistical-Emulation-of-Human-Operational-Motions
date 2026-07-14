%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CreateVideos - The code is an additional tool to visualize the simulated
% data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
addpath('.\02_Functions\')

set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

%% Worker Motion
load .\01_Data\RWP_1_Outcome_300.mat
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
%% ISTVF
load .\06_results\WorkerData\ISTVF\run_1.mat

Xnew = Result.SimulatedData(1,:);

I = randperm(60,5);
for i = 1:5
    filenames = strcat('Video_Motion_1_',num2str(i),'_ISTVF');
    CreateVideo(aligned{I(i)},Xnew{I(i)}, len1, tree, filenames, 8, 50)
end

%% SIEM
load .\06_results\WorkerData\SIEM\run_1.mat

Xnew = Result.SimulatedData(1,:);

I = randperm(60,5);
for i = 1:5
    filenames = strcat('Video_Motion_1_',num2str(i),'_SIEM');
    CreateVideo(aligned{I(i)},Xnew{I(i)}, len1, tree, filenames, 8, 50)
end


%% Exercise Data
load .\01_data\MotionNew_Outcome_800.mat
[~, len2] = skeleton_to_posture(Ref_pos_data, tree);
%% ISTVF
load .\06_results\ExerciseData\ISTVF\run_1.mat

Xnew = Result.SimulatedData(1,:);

I = randperm(60,1);

filenames = strcat('Video_ExerciseMotion_',num2str(i),'_ISTVF');
CreateVideo_New(X{I(i)},Xnew{I(i)}, len2, tree, filenames, 16, 50)


%% SIEM
load .\06_results\ExerciseData\SIEM\run_1.mat

Xnew = Result.SimulatedData(1,:);

I = randperm(60,1);

filenames = strcat('Video_ExerciseMotion_',num2str(i),'_SIEM');
CreateVideo_New(X{I(i)},Xnew{I(i)}, len2, tree, filenames, 16, 50)



