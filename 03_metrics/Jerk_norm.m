%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jerk_norm - The code is to compute norm of jerk
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E = Jerk_norm(J)

T = size(J,1);
dt = 1/(T-1);
J_squared = sum(J.^2, 3);
E = sum(J_squared, 'all')*dt;

end
