pragma circom 2.1.8;

// erased first two lines of this file because they have no relation with this task

template IsTribonacci(n) {
    signal input in[n];
    assert (n >= 3);

    // check if in[n] is a tribonacci sequence
    // 0, 1, 1, 2, 4, 7, 13, 24, 44, ...
    // The three first are 0, 1, 1,
    // the rest are the sum of the previous three
    // circuit must work for arbitrary n


    0 === in[0];
    1 === in[1];
    1 === in[2];

    for (var x = 3; x < n; x++) {
        in[x] === in[x-1] + in[x-2] + in[x-3];
    }

}

component main = IsTribonacci(9);