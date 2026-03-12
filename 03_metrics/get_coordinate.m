%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get_coordinate - The code is to compute the ralative coordination of two landmarks
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [V, theta] = get_coordinate(X1,X2)

    % z-axis = parent vector
    z_axis = X1; % already normalized

    % Choose arbitrary temp vector not parallel to z_axis
    temp = [0, 1, 0];
    if abs(dot(z_axis, temp)) > 0.99
        temp = [1, 0, 0];
    end

    % Orthogonal axes
    x_axis = cross(temp, z_axis);
    x_axis = x_axis / norm(x_axis);
    y_axis = cross(z_axis, x_axis);

    % Rotation matrix (global -> local frame)
    R = [x_axis; y_axis; z_axis];

    % Project v into local frame
    V = (R * X2')'; % row vector

    r = norm(V); % should be ~1 since v is normalized
    theta(1) = acosd(V(3) / r);         % Polar angle from z-axis
    theta(2) = atan2d(V(2), V(1));  % Azimuth in x-y plane

end
