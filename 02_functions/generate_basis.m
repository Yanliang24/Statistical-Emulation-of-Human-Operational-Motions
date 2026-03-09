function [V,W] = generate_basis(Posture)

    [n, p] = size(Posture);
    V = zeros(n, p);
    W = zeros(n, p);

    for i = 1:n
        z = null(Posture(i, :)); 
        z = z';
        V(i, :) = z(1, :);
        W(i, :) = z(2, :);
    end