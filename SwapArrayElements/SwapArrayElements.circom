pragma circom 2.1.8;

// Create template that swaps two elements in an array based on their indexes.
// If either index is out of bounds, the proving should fail.

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/multiplexer.circom";

template Swap(n) {
    signal input in[n];
    signal input x;
    signal input y;
    signal output out[n];

    component less_x = LessThan(252);
    less_x.in[0] <== x;
    less_x.in[1] <== n;
    less_x.out === 1;

    component greater_x = GreaterEqThan(252);
    greater_x.in[0] <== x;
    greater_x.in[1] <== 0;
    greater_x.out === 1;

    component less_y = LessThan(252);
    less_y.in[0] <== y;
    less_y.in[1] <== n;
    less_y.out === 1;

    component greater_y = GreaterEqThan(252);
    greater_y.in[0] <== y;
    greater_y.in[1] <== 0;
    greater_y.out === 1;

    component val_x = Multiplexer(1, n);
    val_x.sel <== x;
    for (var i = 0; i < n; i++) {
        val_x.inp[i][0] <== in[i];
    }

    // get the value at y
    component val_y = Multiplexer(1, n);
    val_y.sel <== y;
    for (var i = 0; i < n; i++) {
        val_y.inp[i][0] <== in[i];
    }

    component eq_x[n];
    component eq_y[n];
    
    signal y_eq_i_mul_x[n];
    signal y_neq_i_mul_i[n];
    signal x_eq_i_mul_y[n];
    
    signal branchX[n];
    signal branchY[n];
    signal branchNeither[n];
    
    for (var i = 0; i < n; i++) {
        // calculating (x==i)*val_y + (y==i)*val_x + (i!=x && i!=y)*val_i does not work if x==y
        // so we just need to exclude one of (x==i)*val_y + (y==i)*val_x when x==y
        // (x==i)*val_y + (y==i && x!=y)*val_x + (i!=x && i!=y)*val_i is sufficient where x!=y can be replaced by x!=i
        // trying to minimize num of multiplications (x==i)*val_y + (x!=i)*( (y==i)*val_x + (i!=y)*val_i )

        eq_x[i] = IsEqual();
        eq_x[i].in[0] <== i;
        eq_x[i].in[1] <== x;

        eq_y[i] = IsEqual();
        eq_y[i].in[0] <== i;
        eq_y[i].in[1] <== y;

        y_eq_i_mul_x[i] <== eq_y[i].out * val_x.out[0];
        
        y_neq_i_mul_i[i] <== (1 - eq_y[i].out) * in[i];
        
        x_eq_i_mul_y[i] <== eq_x[i].out * val_y.out[0];
        
        out[i] <== x_eq_i_mul_y[i] + (1 - eq_x[i].out)*(y_eq_i_mul_x[i] + y_neq_i_mul_i[i]);
    }
}

component main = Swap(6);