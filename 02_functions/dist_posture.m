%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dist_posture - The code is to compute the shape distance between posture1 and posture2
% 
% Implemented based on Anonymous
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d] = dist_posture(posture1, posture2)

a1 = posture1;
a2 = posture2;
ss = diag(a1 * a2'); 
ss = sign(ss).* min(abs(ss), 1);
d = sum(acos(ss));
