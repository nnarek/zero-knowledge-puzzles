pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// Create a circuit that is satisfied if `numerator`,
// `denominator`, `quotient`, and `remainder` represent
// a valid integer division. You will need a comparison check, so
// we've already imported the library and set n to be 252 bits.
//
// Hint: integer division in Circom is `\`.
// `/` is modular division
// `%` is integer modulus

template IntDiv(n) {
    signal input numerator;
    signal input denominator;
    signal input quotient;
    signal input remainder;

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

    // remainder === numerator % denominator; // this contains few multiplication 
    // following check is unneccessary, but it is cheap and works only in prover side
    signal remainder_calc <-- numerator % denominator;
    remainder_calc === remainder; // this one only checked in compile time 
}

component main = IntDiv(252);
