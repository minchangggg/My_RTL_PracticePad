// ================================
// Half Adder Module
// This module performs the basic half-adder logic,
// which computes the sum and carry-out of two 1-bit binary inputs.
// ================================
module half_adder (A, B, S, C);
  input wire A,B; 	// A: First input bit, B: Second input bit
  output wire S,C;	// S(sum): XOR of A and B, C(carry): AND of A and B

  // Logic for sum and carry
  // assign {C, S} = A + B;
  // assign {C, S} = {A & B, A ^ B};
  assign S = A ^ B;
  assign C = A & B;
endmodule
