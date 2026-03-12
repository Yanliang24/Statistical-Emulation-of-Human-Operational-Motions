%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exp_At_Posture - The code is to map vector V at the tangent space of Posture to the shape space
% 
% Implemented based on Anonymous
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Posture1] = Exp_At_Posture(Posture, V)

nF = vecnorm(V, 2, 2);
Fn = V ./ nF;
Fn(nF == 0, :) = 0;

Posture1 = Posture .* cos(nF) + Fn .* sin(nF);
