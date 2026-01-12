pragma circom 2.1.8;

// Create constraints that enforces all signals
// in `in` are binary, i.e. 0 or 1.

template AllBinary(n) {
    signal input in[n];

    for(var x = 0; x < n; x++) {
        0 === in[x]*(1-in[x]);
    }
}

component main = AllBinary(4);
