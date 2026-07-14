%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to generate videos for the Worker Motion data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function v = CreateVideo(X1,X2, len1, tree, filename, fr, quality)
    [~,T1,~] = size(X1);
    [~,T2,~] = size(X2);
    
    if ~ischar(filename)
        error('Error. Input must be a char.')
    end

    if T1 ~= T2
        error('Error. X1 and X2 must be same size')
    end

    T = T1;
    skeleton_data_1 = posture_to_skeleton(X1, len1, tree);
    skeleton_data_2 = posture_to_skeleton(X2, len1, tree);
    for j = 1:T
        f1 = figure(1000);clf;
        set(gcf, 'Position', [0 0 800 400]);
        subplot(1,2,1)
        DrawSkeletonSequenceAction(skeleton_data_1(:,j,:),1,'r','b', 16,1);
        title(['Original t=',num2str(j)])
        drawnow;
        subplot(1,2,2)
        DrawSkeletonSequenceAction(skeleton_data_2(:,j,:),1,'r','k', 16,1);
        title(['Simulated t=',num2str(j)])
        drawnow;
        frame(j) = getframe(gcf); 
    end
    
    FileName=sprintf('%s.mp4',filename);   
    video = VideoWriter(FileName,'MPEG-4');
    video.FrameRate = fr;
    video.Quality = quality;
    open(video)
    writeVideo(video, frame);
    close(video);
    close(f1);

    end
    