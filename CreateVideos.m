clear
addpath('.\MotionCode\')
addpath('.\02_Functions\')

set(0,'defaulttextinterpreter','latex', 'DefaultLegendInterpreter', 'latex')

%% Worker Motion
load .\01_Data\RWP_1_Outcome_300.mat

%% ISTVF
load .\06_Result\WorkerData\ISTVF\run_1.mat

Xnew = Result.SimulatedData(1,:);

I = randperm(60,5);
for i = 1:5
    filenames = strcat('Video_Motion_1_',num2str(i),'_ISTVF');
    CreateVideo(aligned{I(i)},Xnew{I(i)}, len1, tree, filenames, 8, 50)
end

%% SIEM
load .\06_Result\WorkerData\SIEM\run_1.mat

Xnew = Result.SimulatedData(1,:);

I = randperm(60,5);
for i = 1:5
    filenames = strcat('Video_Motion_1_',num2str(i),'_SIEM');
    CreateVideo(aligned{I(i)},Xnew{I(i)}, len1, tree, filenames, 8, 50)
end

%% Exercise Data
load .\01_Data\MotionNew_Outcome_800.mat

%% ISTVF
load .\06_Result\ExerciseData\ISTVF\run_1.mat

Xnew = Result.SimulatedData(1,:);

I = randperm(60,5);
for i = 1:5
    filenames = strcat('Video_ExerciseMotion_',num2str(i),'_ISTVF');
    CreateVideo(aligned{I(i)},Xnew{I(i)}, len1, tree, filenames, 8, 50)
end

%% SIEM
load .\06_Result\ExerciseData\SIEM\run_1.mat

Xnew = Result.SimulatedData(1,:);

I = randperm(60,5);
for i = 1:5
    filenames = strcat('Video_ExerciseMotion_',num2str(i),'_SIEM');
    CreateVideo(aligned{I(i)},Xnew{I(i)}, len1, tree, filenames, 8, 50)
end

CreateVideo_New(X{1}, XNew{2,1},len1,tree, 'Motion_New_SIEM', 8, 75)
