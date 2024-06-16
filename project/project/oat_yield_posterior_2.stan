data {
    int<lower=0> N;
    array[N] real precipitation_june;
    array[N] real average_temperature_may;
    array[N] real sum_of_precipation;
    array[N] real yields;
}

parameters {
    real a;
    real b;
    real c;
    real d;
    array[N] real<lower=-1, upper=1> r_raw;
    real<lower=0> sigma;
}

transformed parameters {
    array[N] real<lower=0, upper=1> r;
    for (i in 1:N) {
        r[i] = 1 - abs(r_raw[i]);
    }
}

model {
    a ~ normal(24, 12);
    b ~ normal(0.109, 0.0545);
    c ~ normal(0.764, 0.382);
    d ~ normal(0.00433, 0.002165);

    for (i in 1:N) {
        real deviation = sum_of_precipation[i] - 250;
        real nu = 1 + abs(deviation) / 50;
        real scale;
        if (deviation < 0) {
            scale = pow(abs(deviation) / 100, 2);
        } else {
            scale = abs(deviation) / 200;
        }
        r_raw[i] ~ student_t(nu, 0, scale); 

        yields[i] ~ normal(r[i]*a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), sigma);
    }
}

generated quantities {
    array[N] real yields_pred;
    array[N] real log_lik;
    for (i in 1:N) {
        log_lik[i] = normal_lpdf(yields[i] | a*r[i] - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), sigma);
        yields_pred[i] = normal_rng(a*r[i] - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), sigma);
    }
}