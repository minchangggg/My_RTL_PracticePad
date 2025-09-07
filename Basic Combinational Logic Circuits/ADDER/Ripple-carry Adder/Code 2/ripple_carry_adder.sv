// ============================================================
// ripple_carry_adder Module
// This parameterized module constructs an N-bit ripple carry adder 
// using N instances of the full_adder module. 
// It takes two N-bit inputs (a and b), a carry-in (cin), 
// and produces an N-bit sum and a final carry-out (cout).
// ============================================================
module ripple_carry_adder #(parameter WIDTH = 16) (
  input logic [WIDTH-1:0]  a, b, // Input: Two N-bit binary numbers (a and b)
  input logic              cin,  // Input: Carry-in bit
  output logic [WIDTH-1:0] sum,  // Output: N-bit sum of a and b with carry-in
  output logic             cout  // Output: Final carry-out bit
);
  
  logic [WIDTH:0] c; // Internal carry wires
  
  assign c[0] = cin; // Initial carry-in

  // Generate N full adder instances for each bit
  genvar i;
  generate
    for (i = 0; i < WIDTH ; i = i + 1) begin : gen_fa
      full_adder fa (
        .a(a[i]), 
        .b(b[i]), 
        .cin(c[i]),
        .sum(sum[i]), 
        .cout(c[i+1])
      );
    end
  endgenerate

  assign cout = c[WIDTH];  // Assign final carry-out
endmodule

// ================================
// Full Adder Module 
// This module implements a full adder 
// taking three 1-bit bin inputs (a, b, cin) and producing a 1-bit sum and cout.
// ================================
module full_adder (
  input logic  a, b, 
  input logic  cin,
  output logic sum, 
  output logic cout
);
  assign {cout, sum} = {((a & b) | (b & cin) | (a & cin)), (a ^ b ^ cin)};
endmodule
