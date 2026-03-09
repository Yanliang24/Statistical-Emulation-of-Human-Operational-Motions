import numpy as np
import tensorflow as tf
import gpflow

gpflow.config.set_default_float(np.float64)

# ======================================================
# Function: prepare training data
# ======================================================
def prepare_training_data(t, Y):

    N, T, D = Y.shape
    t_col = t.reshape(-1, 1)

    X_blocks, Y_blocks = [], []
    for d in range(D):
        times_repeated = np.tile(t_col, (N, 1))               # (N*T,1)
        output_idx_col = np.full((N * T, 1), d, dtype=float)  # (N*T,1)
        X_aug = np.hstack([times_repeated, output_idx_col])   # (N*T,2)
        Y_aug = Y[:, :, d].reshape(-1, 1).astype(np.float64)  # (N*T,1)

        X_blocks.append(X_aug)
        Y_blocks.append(Y_aug)

    X_train = np.vstack(X_blocks).astype(np.float64)
    Y_train = np.vstack(Y_blocks).astype(np.float64)
    return X_train, Y_train

# ======================================================
# Function: build and train SVGP model
# ======================================================
def fit_svgp_model(t, Y, M=150, n_steps=200, batch_size=1024, kernel_type="matern52"):
    """
    Fit an SVGP model given time vector t and data Y (N,T,D).
    Returns the fitted GPflow model.
    """
    N, T, D = Y.shape
    X_train, Y_train = prepare_training_data(t, Y)

    # Define kernel
    if kernel_type.lower() == "rbf":
        k_time = gpflow.kernels.SquaredExponential(active_dims=[0])
    elif kernel_type.lower() == "matern32":
        k_time = gpflow.kernels.Matern32(active_dims=[0])
    elif kernel_type.lower() == "matern12":
        k_time = gpflow.kernels.Matern12(active_dims=[0])
    else:  # default to Matern52
        k_time = gpflow.kernels.Matern52(active_dims=[0])

    coreg = gpflow.kernels.Coregion(output_dim=D, rank=1, active_dims=[1])
    kernel = k_time * coreg

    # Inducing points
    Z_time = np.linspace(t.min(), t.max(), M).reshape(-1, 1)
    Z = np.vstack([np.column_stack([Z_time, np.full((M, 1), d)]) for d in range(D)])

    model = gpflow.models.SVGP(
        kernel=kernel,
        likelihood=gpflow.likelihoods.Gaussian(),
        inducing_variable=Z,
        num_latent_gps=1,
        whiten=True,
    )

    # Init variational params
    Mq = model.q_mu.shape[0]
    model.q_sqrt.assign(np.eye(Mq)[None, :, :] * 0.5)
    model.likelihood.variance.assign(0.01)

    # Dataset for minibatch training
    dataset = tf.data.Dataset.from_tensor_slices((X_train, Y_train))
    dataset = dataset.shuffle(buffer_size=10000, reshuffle_each_iteration=True).repeat().batch(batch_size)
    iterator = iter(dataset)

    opt = tf.optimizers.Adam(learning_rate=1e-3)

    @tf.function
    def train_step():
        Xb, Yb = next(iterator)
        with tf.GradientTape() as tape:
            elbo = model.elbo((Xb, Yb))
            loss = -elbo
        grads = tape.gradient(loss, model.trainable_variables)
        opt.apply_gradients(zip(grads, model.trainable_variables))
        return elbo

    for step in range(n_steps):
        elbo_val = train_step().numpy()
        if step % 500 == 0 or step == n_steps - 1:
            print(f"Step {step}/{n_steps}  ELBO = {elbo_val:.6e}")

    return model

# ======================================================
# Function: sample trajectories from a fitted model
# ======================================================
def sample_from_model(model, t, D, T, n_sims=10):
    """
    Sample new trajectories from a fitted SVGP model.
    
    Args:
        model: trained GPflow SVGP
        t: 1D time vector (T,)
        D: number of output dimensions
        T: number of time points
        n_sims: number of simulations

    Returns:
        samples: array with shape (D, n_sims, T)
    """
    t_star = np.linspace(t.min(), t.max(), T).reshape(-1, 1)
    X_test = np.vstack([np.hstack([t_star, np.full((T, 1), d)]) for d in range(D)]).astype(np.float64)

    mean, cov = model.predict_f(X_test, full_cov=True)
    mean = mean.numpy().flatten()
    cov = cov.numpy()
    if cov.ndim == 3:  # sometimes (1,N,N)
        cov = cov[0]

    cov += 1e-6 * np.eye(cov.shape[0])  # jitter

    sims = np.random.multivariate_normal(mean, cov, size=n_sims)  # (n_sims, D*T)
    sims = sims.reshape(n_sims, D, T)
    sims = np.transpose(sims, (2, 0, 1))  # (T, n_sims, N)
    return sims

def train_svgp(matlab_data, n_steps, kernel_type="matern52"):
    # Transpose MATLAB [T, N, D] -> [N, T, D]
    Y = np.swapaxes(np.array(matlab_data, dtype=np.float64), 0, 1)
    N, T, D = Y.shape
    
    # Flexible time vector based on T
    t = np.linspace(0, 1, T).reshape(-1, 1)
    
    print(f"Training SVGP")
    model = fit_svgp_model(t, Y, M=150, n_steps=int(n_steps), batch_size=1024, kernel_type=kernel_type)
    return model

def sample_svgp(model, D, T, n_sims, seed_val):

    np.random.seed(int(seed_val))
    tf.random.set_seed(int(seed_val))
    
    # Generate time vector for prediction
    t = np.linspace(0, 1, int(T)).reshape(-1, 1)
    
    # Reuse your existing sample_from_model logic
    sims = sample_from_model(model, t, int(D), int(T), n_sims=int(n_sims))
    
    # Return (D, n_sims, T) as contiguous array for MATLAB
    return np.ascontiguousarray(sims)