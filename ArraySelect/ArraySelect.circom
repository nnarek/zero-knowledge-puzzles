pragma circom 2.1.8;

include "../node_modules/circomlib/circuits/comparators.circom";

// Create template that selects an element from an array based on an index.
// Should fail if index is out of bounds

template ArraySelect(n) {
    signal input in[n];
    signal input index;
    signal output out;

    component less = LessThan(252);
    less.in[0] <== index;
    less.in[1] <== n;
    less.out === 1; 

    component greater = GreaterEqThan(252);
    greater.in[0] <== index;
    greater.in[1] <== 0;
    greater.out === 1;

    // we can just return (index==0)*in0 + (index==1)*in1 + ...
    // not sure that we can solve with o(log(n)) sized circuits
    // we can compare index with n/2 and decide which half to go to
    // but we can not branch the circuit based on that comparison
    // so we would need to build both halves anyway and we have o(n) size again
    component eq[n];
    signal sum[n+1];
    sum[0] <== 0;
    for (var i = 0; i < n; i++) {
        eq[i] = IsEqual();
        eq[i].in[0] <== index;
        eq[i].in[1] <== i;

        sum[i+1] <== sum[i] + eq[i].out * in[i];
    }

    out <== sum[n];
}

component main = ArraySelect(4);