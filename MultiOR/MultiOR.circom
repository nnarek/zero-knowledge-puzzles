pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that returns true when at least one
// element is 1. It should return false if all elements
// are 0. It should be unsatisfiable if any of the inputs
// are not 0 or not 1.

template MultiOR(n) {
    signal input in[n];
    signal output out;

    component eq[n];
    var count = 0;
    for (var x = 0; x < n; x++) {
        eq[x] = IsEqual();
        eq[x].in[0] <== in[x];
        eq[x].in[1] <== 1;
        count += eq[x].out;

        0 === in[x]*(in[x] - 1);
    }

    component is_zero = IsZero();
    is_zero.in <== count;
    out <== 1-is_zero.out;
}

component main = MultiOR(4);
