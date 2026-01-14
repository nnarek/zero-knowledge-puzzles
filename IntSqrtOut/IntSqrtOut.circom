pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Be sure to solve IntSqrt before solving this 
// puzzle. Your goal is to compute the square root
// in the provided function, then constrain the answer
// to be true using your work from the previous puzzle.
// You can use the Bablyonian/Heron's or Newton's
// method to compute the integer square root. Remember,
// this is not the modular square root.

// We need to find biggest mid such that its square is less or equal to x. we need to check whether mid*mid <= x && x <(mid+1)(mid+1) if yes there return mid
function intSqrtFloor(x) {
    var low = 0;
    var high = x;
    var mid;
    while (low < high) {
        mid = (low + high) \ 2;
        if (mid * mid <= x && x < (mid + 1) * (mid + 1) ) {
            return mid;
        } else if (mid * mid <= x) { // && (mid + 1) * (mid + 1) <= x
            low = mid+1; // we know that mid is not the answer because "(mid + 1) * (mid + 1) <= x", so we can exclude it
        } else { // x < (mid + 1) * (mid + 1) && x < mid * mid  
            high = mid-1; // mid-1 still can be the answer, because "x < (mid-1 +1)*(mid-1 +1)" is same as "x < mid*mid" and it is valid
        }
    }
    return low;
}

template IntSqrtOut(n) {
    signal input in;
    signal output out;

    out <-- intSqrtFloor(in);
    // constrain out using your
    // work from IntSqrt
    signal a <== LessEqThan(n)([out*out , in]);
    signal b <== LessThan(n)([in, (out + 1)*(out + 1) ]);
    signal c <== LessEqThan(n)([in , 2**n-1]); // prevents overflow
    signal d <== LessEqThan(n)([0, in]); // input can not be negative

    1 === a;
    1 === b;
    1 === c;
    1 === d;
}

component main = IntSqrtOut(252);
