function t_alpha = spherical_kde_confidence_region(X, kappa, alpha)
% SPHERICAL_KDE_CONFIDENCE: KDE with confidence regions on S^2
% kappa: bandwidth (vMF concentration parameter)
% alpha: significance level (e.g., 0.05 for 95% confidence)
    if isempty(kappa)
        % Automatic bandwidth selection (rule of thumb)
        R = norm(mean(Z, 1));
        kappa = (N / R)^(1/3);
        fprintf('Auto-selected kappa = %.3f\n', kappa);
    end

    % Create grid of query points on sphere
    [theta, phi] = meshgrid(linspace(0, pi, 150), linspace(0, 2*pi, 300));
    xq = sin(theta) .* cos(phi);
    yq = sin(theta) .* sin(phi);
    zq = cos(theta);
    query_points = [xq(:), yq(:), zq(:)];

    % Estimate density at query points
    f_hat = spherical_kde(X, kappa, query_points);
    f_hat_grid = reshape(f_hat, size(xq));

    % Estimate threshold t_alpha for (1-alpha) confidence region
    % Here we use quantile of density values at data points
    f_data = spherical_kde(X, kappa, X);
    t_alpha = quantile(f_data, alpha);    
end