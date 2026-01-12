pragma circom 2.1.4;

// Input : 'a',array of length 2 .
// Output : 'c 
// Using a forLoop , add a[0] and a[1] , 4 times in a row .

template ForLoop() {
    signal input a[2];
    signal output c;

    var sum = 0;
    for (var x = 0; x < 4; x++) {
        sum += a[0]+a[1];
    }

    c <== sum;
}  

component main = ForLoop();
