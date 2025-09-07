// Only select ONE of the lines below to define the width
`define ADDER_4BIT
// `define ADDER_2BIT
// `define ADDER_8BIT
// `define ADDER_16BIT

// Chọn độ rộng dựa trên macro define
`ifdef ADDER_2BIT
       parameter WIDTH = 2;    // 2-bit adder
`elsif ADDER_4BIT
       parameter WIDTH = 4;    // 4-bit adder
`elsif ADDER_8BIT
       parameter WIDTH = 8;    // 8-bit adder
`else
       parameter WIDTH = 16;   // Default 16-bit adder
`endif

// ============================================================
// ripple_carry_adder Module
// This parameterized module constructs an N-bit ripple carry adder using N instances of the full_adder module. 
// It takes two N-bit inputs (a and b), a carry-in (cin), and produces an N-bit sum and a final carry-out (cout).
// ============================================================
module ripple_carry_adder (a, b, cin, sum, cout);
  input [WIDTH-1:0] a, b; // Input: Two N-bit binary numbers (a and b)
  input cin;		          // Input: Carry-in bit
  output [WIDTH-1:0] sum; // Output: N-bit sum of a and b with carry-in
  output cout;		        // Output: Final carry-out bit

  wire [WIDTH:0] c; 	    // Internal carry wires
  assign c[0] = cin;   	  // Initial carry-in

  genvar i;
  // Generate N full adder instances for each bit
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
module full_adder (a, b, cin, sum, cout);
  input a,b,cin;
  output sum,cout;

  assign {cout, sum} = {((a & b) | (b & cin) | (a & cin)), (a ^ b ^ cin)};
endmodule
