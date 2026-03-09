function v = CreateSingleVideo(X1,len1, tree, filename, fr)
    [~,T,~] = size(X1);
    
    if ~ischar(filename)
        error('Error. Input must be a char.')
    end

    skeleton_data_1 = posture_to_skeleton(X1, len1, tree);
    for j = 1:T
        f1 = figure(1000);clf;
%         set(gcf, 'Position', [0 0 800 400]);
        DrawSkeletonSequenceAction_SKKU(skeleton_data_1(:,j,:),1,'r','b', 1);
        drawnow;
        frame(j) = getframe(gcf); 
    end
    
    FileName=sprintf('%s.avi',filename);   
    video = VideoWriter(FileName);
    video.FrameRate = fr;
    open(video)
    writeVideo(video, frame);
    close(video);
    close(f1);

    end
    