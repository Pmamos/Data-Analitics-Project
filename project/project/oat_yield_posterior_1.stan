data {
    int<lower=0> N;
    array[N] real precipitation_june;
    array[N] real average_temperature_may;
    array[N] real yields;
}

parameters {
    real a;
    real b;
    real c;
    real d;

    real<lower=0> sigma;
}

model {
    a ~ normal(16, 8);
    b ~ normal(0.109, 0.0545);
    c ~ normal(0.764, 0.382);
    d ~ normal(0.00433, 0.002165);

    for (i in 1:N) {
        yields[i] ~ normal(a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), sigma);
    }
}

generated quantities {
    array[N] real yields_pred;
    array[N] real log_lik;
    for (i in 1:N) {
        log_lik[i] = normal_lpdf(yields[i] | a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), sigma);
        yields_pred[i] = normal_rng(a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), sigma);
    }
}