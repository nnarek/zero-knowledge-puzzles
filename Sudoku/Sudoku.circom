pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

/*
    Given a 4x4 sudoku board with array signal input "question" and "solution", check if the solution is correct.

    "question" is a 16 length array. Example: [0,4,0,0,0,0,1,0,0,0,0,3,2,0,0,0] == [0, 4, 0, 0]
                                                                                   [0, 0, 1, 0]
                                                                                   [0, 0, 0, 3]
                                                                                   [2, 0, 0, 0]

    "solution" is a 16 length array. Example: [1,4,3,2,3,2,1,4,4,1,2,3,2,3,4,1] == [1, 4, 3, 2]
                                                                                   [3, 2, 1, 4]
                                                                                   [4, 1, 2, 3]
                                                                                   [2, 3, 4, 1]

    "out" is the signal output of the circuit. "out" is 1 if the solution is correct, otherwise 0.                                                                               
*/


function factorial (n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}

// check whether input array is permutation of 1...n numbers 
// assuming it is already checked that all elements are positive
template From1ToN(n) {
    assert(n > 0);
    assert(n <= 56); 
    signal input in[n];
    signal output out;

    // circuit size is O(n)  
    var sum = 0;
    signal prod[n+1];
    prod[0] <== 1;
    for(var x = 0; x < n; x++){
        sum += in[x];
        prod[x+1] <== prod[x] * in[x];
    }

    component eq = IsEqual();
    eq.in[0] <== prod[n];
    eq.in[1] <== factorial(n);

    component eq1 = IsEqual();
    eq1.in[0] <== sum;
    eq1.in[1] <== (n*(n+1))/2;

    out <== eq.out * eq1.out;
}

template Sudoku () {
    // Question Setup 
    signal input  question[16];
    signal input solution[16];
    signal output out;
    
    // Checking if the question is valid
    for(var v = 0; v < 16; v++){
        log(solution[v],question[v]);
        assert(question[v] == solution[v] || question[v] == 0);
    }
    
    var m = 0 ;
    component row1[4];
    for(var q = 0; q < 4; q++){
        row1[m] = IsEqual();
        row1[m].in[0]  <== question[q];
        row1[m].in[1] <== 0;
        m++;
    }
    3 === row1[3].out + row1[2].out + row1[1].out + row1[0].out;

    m = 0;
    component row2[4];
    for(var q = 4; q < 8; q++){
        row2[m] = IsEqual();
        row2[m].in[0]  <== question[q];
        row2[m].in[1] <== 0;
        m++;
    }
    3 === row2[3].out + row2[2].out + row2[1].out + row2[0].out; 

    m = 0;
    component row3[4];
    for(var q = 8; q < 12; q++){
        row3[m] = IsEqual();
        row3[m].in[0]  <== question[q];
        row3[m].in[1] <== 0;
        m++;
    }
    3 === row3[3].out + row3[2].out + row3[1].out + row3[0].out; 

    m = 0;
    component row4[4];
    for(var q = 12; q < 16; q++){
        row4[m] = IsEqual();
        row4[m].in[0]  <== question[q];
        row4[m].in[1] <== 0;
        m++;
    }
    3 === row4[3].out + row4[2].out + row4[1].out + row4[0].out; 

    // Write your solution from here.. Good Luck!
    
    // above lines checks that all rows have only one known value
    signal outs[1+16+4+4+4];
    var out_index = 0;
    outs[out_index] <== 1;

    component eq1[16];
    component eq2[16];
    component or[16];
    component greater[16];
    signal and[16];
    // checking that non-zero values of question present in solution too
    for(var q = 0; q < 16; q++){
        eq1[q] = IsEqual();
        eq1[q].in[0] <== question[q];
        eq1[q].in[1] <== 0;

        eq2[q] = IsEqual();
        eq2[q].in[0] <== question[q];
        eq2[q].in[1] <== solution[q];

        or[q] = OR();
        or[q].a <== eq1[q].out;
        or[q].b <== eq2[q].out;

        greater[q] = GreaterThan(252);
        greater[q].in[0] <== solution[q];
        greater[q].in[1] <== 0;

        and[q] <== or[q].out * greater[q].out;

        // we can not just check "and[q] == 1" because in this case we would not able to generate withness 
        // we need to generate withness that solutions is incorrect too, in this case out should be 0 
        outs[out_index+1] <== and[q] * outs[out_index];
        out_index++;
    }

    //checking uniqueness of rows
    component rowUnique[4];
    for(var r = 0; r < 4; r++){
        rowUnique[r] = From1ToN(4);
        for(var c = 0; c < 4; c++){
            rowUnique[r].in[c] <== solution[r*4 + c];
        }
        outs[out_index+1] <== rowUnique[r].out * outs[out_index];
        out_index++;
    }
    
    //checking uniqueness of columns
    component colUnique[4];
    for(var c = 0; c < 4; c++){
        colUnique[c] = From1ToN(4);
        for(var r = 0; r < 4; r++){
            colUnique[c].in[r] <== solution[r*4 + c];
        }
        outs[out_index+1] <== colUnique[c].out * outs[out_index];
        out_index++;
    }

    //checking uniqueness of 2x2 boxes
    component boxUnique[4];
    for(var x = 0; x < 2; x++){
        for(var y = 0; y < 2; y++){
            var bx = x*2; // x coordinate of first element of box
            var by = y*2; // y coordinate of first element of box
            var b = x*2 + y; // id of box
            boxUnique[b] = From1ToN(4);
            for(var ex = 0; ex < 2; ex++){
                for(var ey = 0; ey < 2; ey++){
                    boxUnique[b].in[ex*2 + ey] <== solution[(bx+ex)*4 + by+ey];
                }
            }
            outs[out_index+1] <== boxUnique[b].out * outs[out_index];
            out_index++;
        }
    }

    out <== outs[out_index];
}

component main = Sudoku();


