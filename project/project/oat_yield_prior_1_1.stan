data {
    int<lower=0> N;
    array[N] real precipitation_june;
    array[N] real average_temperature_may;
}

generated quantities {
    real a = normal_rng(41.43, 20.715);
    real b = normal_rng(0.109, 0.0545);
    real c = normal_rng(0.764, 0.382);
    real d = normal_rng(0.00433, 0.002165);

    array[N] real yields;
    for (i in 1:N) {
        yields[i] = normal_rng(a - b*pow(average_temperature_may[i], 2) + c*precipitation_june[i] - d*pow(precipitation_june[i], 2), 1);
    }
}