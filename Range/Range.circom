pragma circom 2.1.4;
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// In this exercise , we will learn how to check the range of a private variable and prove that 
// it is within the range . 

// For example we can prove that a certain person's income is within the range
// Declare 3 input signals `a`, `lowerbound` and `upperbound`.
// If 'a' is within the range, output 1 , else output 0 using 'out'


template Range() {
    signal input a;
    signal input lowerbound;
    signal input upperbound;
    signal output out;

    // TODO mark lowerbound and upperbound as public 
    component and = AND();
    and.a <== LessEqThan(252)([a,upperbound]);
    and.b <== LessEqThan(252)([lowerbound,a]);

    out <== and.out;
}

component main {public [lowerbound,upperbound]} = Range();


