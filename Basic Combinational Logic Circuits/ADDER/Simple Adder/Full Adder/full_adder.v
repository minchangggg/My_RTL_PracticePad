// ================================
// Module: full_adder
// Description: 
//   This module implements a full adder using two half adder instances,
//   taking three 1-bit bin inputs (a, b, cin) and producing a 1-bit sum and cout.
// Inputs:
//   - a, b : input bit
//   - cin  : Carry-in bit
// Outputs:
//   - sum  : Sum output (1-bit)
//   - cout : Carry-out output (1-bit)
// ================================
module full_adder(a, b, cin, sum, cout);
  input wire a, b, cin;   // Input: a (First input bit), b (Second input bit), cin (Carry-in input)
  output wire sum, cout;  // Output: sum (Final sum), cout (Final carry-out)
    
  wire I1, I2, I3;    // Intermediate wires: I1 (sum from ha1), I2 (carry from ha1), I3 (carry from ha2)

  // Instantiate first Half Adder for a and b
  half_adder ha1(.A(a), .B(b), .S(I1), .C(I2));
  // Instantiate second Half Adder for I1 and cin
  half_adder ha2(.A(I1), .B(cin), .S(sum), .C(I3));

  // Final carry-out is OR of both carries
  assign cout = I2 | I3; 
endmodule

// ================================
// Half Adder Module
// This module performs the basic half-adder logic,
// which computes the sum and carry-out of two 1-bit binary inputs.
// ================================
module half_adder (A, B, S, C);
  input A,B; 	// A: First input bit, B: Second input bit
  output S,C;	// S(sum): XOR of A and B, C(carry-out): AND of A and B

  // Logic for sum and carry
  assign {C, S} = {A & B, A ^ B};
endmodule

/*
// ==============================================
// Module: full_adder
// Description: 
//   A 1-bit Full Adder circuit that computes the 
//   binary sum of three 1-bit inputs (a, b, cin).
// Inputs:
//   - a, b : input bit
//   - cin  : Carry-in bit
// Outputs:
//   - sum  : Sum output (1-bit)
//   - cout : Carry-out output (1-bit)
// Logic:
//   sum  = a ^ b ^ cin
//   cout = (a & b) | (b & cin) | (a & cin)
// ==============================================
module full_adder (a, b, cin, sum, cout);
  input a, b, cin;      // Input: a (First input bit), b (Second input bit), cin (Carry-in input)
  output sum, cout;  // Output: sum (Final sum), cout (Final carry-out)

  // Logic for sum and carry
  // assign {cout, sum} = a + b + cin;
  // assign {cout, sum} = {((a & b) | (b & cin) | (a & cin)), (a ^ b ^ cin)};
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (cin & a) ;
endmodule
*/
