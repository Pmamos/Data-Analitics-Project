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
    a ~ normal(41.43, 4.143);
    b ~ normal(0.109, 0.0109);
    c ~ normal(0.764, 0.0764);
    d ~ normal(0.00433, 0.000433);

    for (i in 1:N) {
        yields[i] ~ normal(a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), 1);
    }
}

generated quantities {
    array[N] real yields_pred;
    for (i in 1:N) {
        yields_pred[i] = normal_rng(a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), 1);
    }
}