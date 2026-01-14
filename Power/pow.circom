pragma circom 2.1.4;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 

template Pow() {
   signal input a[2];
   signal output c;

   c <-- a[0] ** a[1];
   // lets try to implement it for very big exponents too, by using binary exponentiation method, in this case circuit will have logarithmic size
   // we can assume that a[1] is less than 2^250
   // we can compute all bits of a[1] without constraints and verify that that bits give a[1] when multiplied by powers of two
   // then we can compute a[0]^(2^i) for all i and multiply those where bit is 1
   signal less <== LessThan(252)([a[1], 1 << 250]);
   signal non_neg <== GreaterEqThan(252)([a[1], 0]);
   1 === less * non_neg;

   signal bits[250];
   signal power_sums[251];
   power_sums[0] <== 0;
   for (var i = 0; i < 250; i++) {
       bits[i] <-- (a[1] >> i) & 1;
       power_sums[i+1] <== power_sums[i] + bits[i] * (1 << i);
   }
   power_sums[250] === a[1];


   signal powers[251];// a[0]^(2^i)   
   powers[0] <== a[0];
   signal power_products[251]; // power_products[250] = a[0]^a[1] = a[0]^(b0*1+b1*2+b2*4+...) = a[0]^(b0*1) * a[0]^(b1*2) * a[0]^(b2*4) * ...
   power_products[0] <== 1;
   signal mul[250];
   for (var i = 0; i < 250; i++) {
      mul[i] <== bits[i] * powers[i] + (1 - bits[i]) * 1; // same as powers[i]**bits[i]
      power_products[i+1] <== power_products[i] * mul[i];
      powers[i+1] <== powers[i] * powers[i];
   }

   c === power_products[250];

}

component main = Pow();

