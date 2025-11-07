data {
  int<lower=1> N;          // total # of (eth, precinct) data points
  int<lower=1> n_eth;      // number of ethnicity categories, e.g. 3
  int<lower=1> n_prec;     // number of precincts
  
  int<lower=0> y[N];       // outcome counts y_{ep}
  vector[N] past_arrests;  // baseline/reference rate
  
  int<lower=1, upper=n_eth> eth[N];      // ethnicity ID for each row
  int<lower=1, upper=n_prec> precinct[N]; // precinct ID for each row
}

parameters {
  // Ethnicity effects (fixed)
  vector[n_eth] alpha; 
  
  // Random intercepts for precinct
  real<lower=0> sigma_beta; 
  vector[n_prec] beta_raw;   // non-centered param for precinct

  // Overdispersion
  real<lower=0> sigma_eps;
  vector[N] eps_raw;         // non-centered param for each (e,p) observation
}

transformed parameters {
  vector[n_prec] beta; 
  beta = sigma_beta * beta_raw;

  vector[N] eps;
  eps = sigma_eps * eps_raw;
}

model {
  // Priors
  alpha ~ normal(0, 5);           
  sigma_beta ~ exponential(1);    
  beta_raw ~ normal(0, 1);

  sigma_eps ~ exponential(1);     
  eps_raw ~ normal(0, 1);
  
  // Likelihood
  for (i in 1:N) {
    y[i] ~ poisson(past_arrests[i] * (15.0 / 12.0) * exp(alpha[eth[i]] + beta[precinct[i]] + eps[i]));
  }
}
