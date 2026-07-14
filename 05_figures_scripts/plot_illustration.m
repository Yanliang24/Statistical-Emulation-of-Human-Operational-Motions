
X1 = aligned{1};
skeleton_data_aligned = posture_to_skeleton(X1, len1, tree);   

f = figure;
DrawSkeletonSequenceAction_slim(skeleton_data_aligned(:,12:36,:),6,'r','b', 16, 1, -2*1, '' );
set(gca,'InnerPosition', [0.05 0.05 0.9 0.9])
set(gcf,'Position',[100 100 1100 200])
exportgraphics(f, 'motion_detail.png','Resolution',300)

f1 = figure;
tiledlayout(1,2,'TileSpacing','tight','Padding','tight')
nexttile
DrawSkeletonSequenceAction_slim(skeleton_data_aligned(:,12:20,:),2,'r','b', 16, 1, -2*1, '' );
DrawSkeletonSequenceAction_slim(skeleton_data_aligned(:,22:30,:),2,'r','b', 16, 1, -2*2, '' );
set(gca,'InnerPosition', [0.05 0.05 0.9 0.9])


x_sparse = X1(19,12:36,1);
y_sparse = X1(19,12:36,2);
z_sparse = X1(19,12:36,3);

[phi_raw, theta_raw, r_raw] = cart2sph(x_sparse, y_sparse, z_sparse);
t_orig = 1:length(x_sparse);
t_dense = linspace(1, length(x_sparse), 200); % 200 points instead of 10

phi_dense = interp1(t_orig, phi_raw, t_dense, 'spline')';
theta_dense = interp1(t_orig, theta_raw, t_dense, 'spline')';

[x_dense, y_dense, z_dense] = sph2cart(phi_dense, theta_dense, 1);

nexttile
hold on;
grid on;

% 4. Generate a high-resolution background sphere mesh
[sphere_x, sphere_y, sphere_z] = sphere(150); 

% Plot the sphere mesh with light styling so it doesn't overpower the path
surf(sphere_x, sphere_y, sphere_z, 'FaceColor', [0.9 0.9 0.9], ...
     'EdgeColor', [0.7 0.7 0.7], 'FaceAlpha', 0.5, 'EdgeAlpha', 0.3);

% 5. Plot the 3D trajectory path
plot3(x_dense, y_dense, z_dense, 'b-', 'LineWidth', 3);

% Plot your actual 10 data points as distinct markers sitting on top
plot3(x_sparse, y_sparse, z_sparse, 'bo',  ...
      'MarkerFaceColor', 'w', 'MarkerSize', 6, 'LineWidth', 1.5);
axis equal; 
% Label the Start and End points for clarity
text(x_path(1)-0.05, y_path(1), z_path(1), '  Start', 'FontSize', 16, 'FontWeight', 'bold');
text(x_path(end), y_path(end), z_path(end)-0.08, '  End', 'FontSize', 16, 'FontWeight', 'bold');

% 6. ZOOM-IN LOGIC: Calculate tight bounding box with padding
% We find the min/max of the data points and add a small padding (e.g., 0.05)
padding = 0.15; % Increased from 0.04 to pull the camera back
xl = [min(x_sparse) - padding, max(x_sparse) + padding];
yl = [min(y_sparse) - padding, max(y_sparse) + padding];
zl = [min(z_sparse) - padding, max(z_sparse) + padding];
xlim(xl); ylim(yl); zlim(zl);

camproj perspective; 

% Dynamic Tangential Camera View
mean_x = mean(x_sparse); mean_y = mean(y_sparse); mean_z = mean(z_sparse);
[az, el] = cart2sph(mean_x, mean_y, mean_z);
% An offset of 35 degrees forces a striking horizon view
view(rad2deg(az) + 35, rad2deg(el) - 10);
camup([0, 0, -1]);
camlight right; 
lighting gouraud;
hold off;
set(f1,'Position', [100 100 800 400])
exportgraphics(f1,'motion_sphere.pdf','Resolution',300)
