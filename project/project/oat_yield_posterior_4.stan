data {
    int<lower=0> N;
    array[N] real precipitation_april;
    array[N] real precipitation_may;
    array[N] real precipitation_june;
    array[N] real precipitation_july;
    array[N] real average_temperature_april;
    array[N] real average_temperature_may;
    array[N] real average_temperature_june;
    array[N] real average_temperature_july;
    array[N] real yields;
}


parameters {
    real<lower=0> a;
    array[4] real b;
    array[4] real c;
    array[4] real d;
}

model {
    a ~ normal(24.43, 10.43);
    for (m in 1:4) {
        b[m] ~ normal(0.0309, 0.0509);
        c[m] ~ normal(1.764, 2.464);
        d[m] ~ normal(0.00433, 0.000833);
    }

   for (i in 1:N) {
        yields[i] ~ normal(
            a 
            - b[1] * pow(average_temperature_april[i], 2)
            - b[2] * pow(average_temperature_may[i], 2)
            - b[3] * pow(average_temperature_june[i], 2)
            - b[4] * pow(average_temperature_july[i], 2)
            + c[1] * precipitation_april[i]
            + c[2] * precipitation_may[i]
            + c[3] * precipitation_june[i]
            + c[4] * precipitation_july[i]
            - d[1] * pow(precipitation_april[i], 2)
            - d[2] * pow(precipitation_may[i], 2)
            - d[3] * pow(precipitation_june[i], 2)
            - d[4] * pow(precipitation_july[i], 2), 
            1
        );
    }
}

generated quantities {
    array[N] real yields_pred;
    array[N] real log_lik;
    for (i in 1:N) {
        log_lik[i] = normal_lpdf(yields[i] | a 
            - b[1] * pow(average_temperature_april[i], 2)
            - b[2] * pow(average_temperature_may[i], 2)
            - b[3] * pow(average_temperature_june[i], 2)
            - b[4] * pow(average_temperature_july[i], 2)
            + c[1] * precipitation_april[i]
            + c[2] * precipitation_may[i]
            + c[3] * precipitation_june[i]
            + c[4] * precipitation_july[i]
            - d[1] * pow(precipitation_april[i], 2)
            - d[2] * pow(precipitation_may[i], 2)
            - d[3] * pow(precipitation_june[i], 2)
            - d[4] * pow(precipitation_july[i], 2), 1);

        yields_pred[i] = normal_rng(a 
            - b[1] * pow(average_temperature_april[i], 2)
            - b[2] * pow(average_temperature_may[i], 2)
            - b[3] * pow(average_temperature_june[i], 2)
            - b[4] * pow(average_temperature_july[i], 2)
            + c[1] * precipitation_april[i]
            + c[2] * precipitation_may[i]
            + c[3] * precipitation_june[i]
            + c[4] * precipitation_july[i]
            - d[1] * pow(precipitation_april[i], 2)
            - d[2] * pow(precipitation_may[i], 2)
            - d[3] * pow(precipitation_june[i], 2)
            - d[4] * pow(precipitation_july[i], 2),1);
    }
}