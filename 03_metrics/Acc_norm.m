function E = Acc_norm(A)

T = size(A,1);
dt = 1/(T-1);
A_squared = sum(A.^2, 3);
E = sum(A_squared, 'all')*dt;

end