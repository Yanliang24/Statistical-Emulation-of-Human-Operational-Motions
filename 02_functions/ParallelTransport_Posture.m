function [V_par] = ParallelTransport_Posture(Posture, V, Posture1)

tmp = Posture+Posture1;
w = diag(V*Posture1')./diag(tmp*tmp');
V_par=V-2*diag(w)*(Posture+Posture1);
