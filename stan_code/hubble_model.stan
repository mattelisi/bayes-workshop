
data {
  int<lower=1> N;
  vector[N] distance;     // Mpc
  vector[N] velocity;     // km/s
}
parameters {
  real<lower=0> beta;     // (km/s)/Mpc, Hubble slope
  real<lower=0> sigma;    // km/s
}
model {
  // weakly-informative half-normal priors via <lower=0>
  beta  ~ normal(0, 200);
  sigma ~ normal(0, 2000);

  // likelihood
  velocity ~ normal(beta * distance, sigma);
}

