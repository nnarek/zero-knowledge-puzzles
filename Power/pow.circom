pragma circom 2.1.4;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 

template Pow() {
   
   signal input a[2];
   signal output c;

   c <-- a[0] ** a[1];
   // if we know that exponent is less than compile time known n then we can create fixed loop which calculates by multiplication iteratively
   // in this case we can iterate n times and multiply a[0] each time to get the result, if one of results is equal to c then it is valid.

   var limit = 100;

   signal powers[limit+1];
   powers[0] <== 1;
   for(var x=0; x<limit; x++) {
      powers[x+1] <== powers[x] * a[0];
   }
   component eq[limit+1];
   for(var y=0; y<limit+1; y++) {
      eq[y] = IsEqual();
      eq[y].in[0] <== powers[y];
      eq[y].in[1] <== c;
   }
   var sum = 0;
   for(var z=0; z<limit+1; z++) {
      sum = sum + eq[z].out;
   }
   sum === 1;     

}

component main = Pow();

