pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that takes an array of signals `in[n]` and
// a signal k. The circuit should return 1 if `k` is in the list
// and 0 otherwise. This circuit should work for an arbitrary
// length of `in`.

template HasAtLeastOne(n) {
    signal input in[n];
    signal input k;
    signal output out;

    component eq[n];
    var count = 0;
    for (var x = 0; x < n; x++) {
        eq[x] = IsEqual();
        eq[x].in[0] <== in[x];
        eq[x].in[1] <== k;
        count += eq[x].out;
    }

    component is_zero = IsZero();
    is_zero.in <== count;
    out <== 1-is_zero.out;
}

component main = HasAtLeastOne(4);
