
[~, len1] = skeleton_to_posture(Ref_pos_data, tree);
skeleton_data1 = posture_to_skeleton(aligned{10}, len1, tree);
skeleton_data2 = posture_to_skeleton(posture_sequence{10}, len1, tree);
skeleton_data3 = posture_to_skeleton(Ref_posture_sequence, len1, tree);

f1 = figure;
DrawSkeletonSequenceAction_SKKU(skeleton_data1,201,'r','b', 1);
hold on;
DrawSkeletonSequenceAction_SKKU(skeleton_data3,201,'k','k', 1);
hold off;
set(f1,'Position',[10 10 1000 250])
title('Temporally aligned','FontSize',16);
exportgraphics(f1,'Aligned.pdf','Resolution',300)
f2 = figure;
DrawSkeletonSequenceAction_SKKU(skeleton_data2,201,'r','b', 1);
hold on;
DrawSkeletonSequenceAction_SKKU(skeleton_data3,201,'k','k', 1);
hold off;
title('Unaligned','FontSize',16);
set(f2,'Position',[10 10 1000 250])
exportgraphics(f2,'Unaligned.pdf','Resolution',300)