pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that constrains the 4 input signals to be
// sorted. Sorted means the values are non decreasing starting
// at index 0. The circuit should not have an output.

template IsSorted() {
    signal input in[4];

    component less[4-1];

    for (var x = 0; x < 3; x++) {
        less[x] = LessEqThan(252);
        less[x].in[0] <== in[x];
        less[x].in[1] <== in[x+1];
        less[x].out === 1;
    }
}

component main = IsSorted();
