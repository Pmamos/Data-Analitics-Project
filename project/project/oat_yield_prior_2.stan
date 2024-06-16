data {
    int<lower=0> N;
    array[N] real precipitation_june;
    array[N] real average_temperature_may;
    array[N] real sum_of_precipation;
}

generated quantities {
    real a = normal_rng(24, 12);
    real b = normal_rng(0.109, 0.0545);
    real c = normal_rng(0.764, 0.382);
    real d = normal_rng(0.00433, 0.002165);

    array[N] real yields;
    array[N] real r;
    array[N] real r_l;
    for (i in 1:N) {
        real deviation = sum_of_precipation[i] - 250;
        real nu = 1 + abs(deviation) / 50;
        real scale;
        if (deviation < 0) {
            scale = pow(abs(deviation) / 100, 2); 
        } else {
            scale = abs(deviation) / 200; 
        }
        real r_raw = student_t_rng(nu, 0, scale); 
        r[i] = 1 - abs(r_raw);

        yields[i] = normal_rng(a*r[i] - b * pow(average_temperature_may[i], 2) + c * precipitation_june[i] - d * pow(precipitation_june[i], 2), 1);
    }
}