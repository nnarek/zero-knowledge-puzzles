pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that takes an array of signals `in` and
// returns 1 if all of the signals are 1. If any of the
// signals are 0 return 0. If any of the signals are not
// 0 or 1 the circuit should not be satisfiable.

template MultiAND(n) {
    signal input in[n];
    signal output out;

    component eq[n];
    var count = 0;
    for (var x = 0; x < n; x++) {
        eq[x] = IsEqual();
        eq[x].in[0] <== in[x];
        eq[x].in[1] <== 0;
        count += eq[x].out;

        0 === in[x]*(in[x] - 1);
    }

    component is_zero = IsZero();
    is_zero.in <== count;
    out <== is_zero.out;

}

component main = MultiAND(4);
