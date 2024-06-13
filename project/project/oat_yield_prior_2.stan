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
}

generated quantities {
    real a = normal_rng(24.43, 10.43);
    array[4] real b;
    array[4] real c;
    array[4] real d;

    // Generowanie parametrów dla każdego miesiąca
    for (m in 1:4) {
        b[m] = normal_rng(0.109, 0.209);
        c[m] = normal_rng(0.764, 1.464);
        d[m] = normal_rng(0.00433, 0.00833);
    }

    array[N] real yields;
    for (i in 1:N) {
        yields[i] = normal_rng(a 
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
