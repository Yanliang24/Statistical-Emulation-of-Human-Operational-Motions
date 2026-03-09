function [Posture1] = Exp_At_Posture(Posture, V)

nF = vecnorm(V, 2, 2);
Fn = V ./ nF;
Fn(nF == 0, :) = 0;
Posture1 = Posture .* cos(nF) + Fn .* sin(nF);