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
}

model {
    a ~ normal(24.43, 20);
    b ~ normal(0.109, 0.0509);
    c ~ normal(3.764, 2.064);
    d ~ normal(0.0433, 0.00833);

    for (i in 1:N) {
        yields[i] ~ normal(a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), 1);
    }
}

generated quantities {
    array[N] real yields_pred;
    array[N] real log_lik;
    for (i in 1:N) {
        log_lik[i] = normal_lpdf(yields[i] | a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), 1);
        yields_pred[i] = normal_rng(a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), 1);
    }
}