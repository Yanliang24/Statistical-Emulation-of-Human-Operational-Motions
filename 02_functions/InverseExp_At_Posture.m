function [V] = InverseExp_At_Posture(Posture, Posture1)

c_theta = sum(Posture .* Posture1, 2);
c_theta = max(min(c_theta, 1), -1);
theta = acos(c_theta);
d = theta ./ sin(theta);
d(theta == 0 | isnan(d)) = 1; 
V = d .* (Posture1 - c_theta .* Posture);



 