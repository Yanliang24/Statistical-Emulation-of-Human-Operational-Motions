function v = CreateVideo_Compare(X1,X2,X3,X4, len1, tree, filename, fr, quality)
    [~,T1,~] = size(X1);
    [~,T2,~] = size(X2);
    [~,T3,~] = size(X3);
    [~,T4,~] = size(X4);

    if ~ischar(filename)
        error('Error. Input must be a char.')
    end

    if T1 ~= T2
        error('Error. X1 and X2 must be same size')
    end

    T = T1;
    skeleton_data_1 = posture_to_skeleton(X1, len1, tree);
    skeleton_data_2 = posture_to_skeleton(X2, len1, tree);
    skeleton_data_3 = posture_to_skeleton(X3, len1, tree);
    skeleton_data_4 = posture_to_skeleton(X4, len1, tree);
    for j = 1:T
        f1 = figure(1000);clf;
        set(gcf, 'Position', [0 0 1200 300]);
        subplot(1,4,1)
        DrawSkeletonSequenceAction_SKKU(skeleton_data_1(:,j,:),1,'r','b', 1);
        title('Original')
        drawnow;
        subplot(1,4,2)
        DrawSkeletonSequenceAction_SKKU(skeleton_data_2(:,j,:),1,'r','k', 1);
        title('Original Recon')
        drawnow;
        subplot(1,4,3)
        DrawSkeletonSequenceAction_SKKU(skeleton_data_3(:,j,:),1,'r','k', 1);
        title('Noisy Recon')
        drawnow;
        subplot(1,4,4)
        DrawSkeletonSequenceAction_SKKU(skeleton_data_4(:,j,:),1,'r','k', 1);
        title('Noisy')
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
    