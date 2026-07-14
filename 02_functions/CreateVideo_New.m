%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to generate videos for the Exercise Motion data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function v = CreateVideo_New(X1,X2, len1, tree, filename, fr, quality)
    [~,T1,~] = size(X1);
    [~,T2,~] = size(X2);
    
    if ~ischar(filename)
        error('Error. Input must be a char.')
    end

    if T1 ~= T2
        error('Error. X1 and X2 must be same size')
    end

    T = T1;
    skeleton_data_1 = posture_to_skeleton_new(X1, len1, tree);
    skeleton_data_2 = posture_to_skeleton_new(X2, len1, tree);
    for j = 1:T
        f1 = figure(1000);clf;
        set(gcf, 'Position', [0 0 800 400]);
        subplot(1,2,1)
        DrawSkeleton_New(squeeze(skeleton_data_1(:,j,:)),tree,'r','b');
        drawnow;
        subplot(1,2,2)
        DrawSkeleton_New(squeeze(skeleton_data_2(:,j,:)),tree,'r','k');
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
    