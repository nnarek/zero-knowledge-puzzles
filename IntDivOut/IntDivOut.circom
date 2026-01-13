pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// Use the same constraints from IntDiv, but this
// time assign the quotient in `out`. You still need
// to apply the same constraints as IntDiv

template IntDivOut(n) {
    signal input numerator;
    signal input denominator;
    signal output out;

    out <-- numerator \ denominator;

    signal remainder <-- numerator % denominator;
    signal quotient <== out;

    // copied from my solution of IntDiv.circom
    numerator === quotient * denominator + remainder;

    // reminder < denominator if denominator is positive 
    signal remainder_positive <== GreaterEqThan(n)([remainder,0]);
    signal remainder_less_denom <== LessThan(n)([remainder,denominator]);

    // reminder > denominator if denominator is negaitve 
    signal remainder_negative <== LessEqThan(n)([remainder,0]);
    signal remainder_greater_denom <== GreaterThan(n)([remainder,denominator]);

    component or = OR();
    or.a <== remainder_positive * remainder_less_denom; //AND operation
    or.b <== remainder_negative * remainder_greater_denom;

    1 === or.out;

    component is_zero = IsZero();
    is_zero.in <== denominator;
    0 === is_zero.out; 
}

component main = IntDivOut(252);
