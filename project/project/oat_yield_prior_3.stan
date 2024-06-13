data {
    int<lower=0> N;
    array[N] real precipitation_june;
    array[N] real average_temperature_may;
}

generated quantities {
    real a = normal_rng(24.43, 20);
    real b = normal_rng(0.109, 0.0509);
    real c = normal_rng(5.764, 2.764);
    real d = normal_rng(0.0433, 0.00833);

    array[N] real yields;
    for (i in 1:N) {
        yields[i] = normal_rng(a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), 1);
    }
}