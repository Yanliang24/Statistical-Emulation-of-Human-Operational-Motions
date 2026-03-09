function [d] = dist_posture(posture1, posture2)

a1 = posture1;
a2 = posture2;
ss = diag(a1 * a2'); 
ss = sign(ss).* min(abs(ss), 1);
d = sum(acos(ss));


    