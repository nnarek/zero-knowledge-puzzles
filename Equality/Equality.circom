pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

template Equality() {
   signal input a[3];
   signal output c;

   component and1 = AND();

   and1.a <== IsEqual()([a[0],a[1]]);
   and1.b <== IsEqual()([a[1],a[2]]);

   c <== and1.out;
}

component main = Equality();