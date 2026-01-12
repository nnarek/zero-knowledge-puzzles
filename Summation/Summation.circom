pragma circom 2.1.8;

template Summation(n) {
    signal input in[n];
    signal input sum;

    // constrain sum === in[0] + in[1] + in[2] + ... + in[n-1]
    // this should work for any n

    var current_sum = 0;
    for (var x = 0; x < n; x++) {
        current_sum += in[x];
    }

    sum === current_sum;
}

component main = Summation(8);