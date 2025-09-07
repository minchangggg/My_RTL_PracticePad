// Define widths for different adder configurations
`define WIDTH_2  2
`define WIDTH_4  4
`define WIDTH_8  8
`define WIDTH_16 16

module tb_ripple_carry_adder;
  // Common carry-in signal
  logic CIN;

  // Signals for 2-bit adder
  logic [1:0] A2, B2;
  logic [1:0] SUM2;
  logic COUT2;

  // Signals for 4-bit adder
  logic [3:0] A4, B4;
  logic [3:0] SUM4;
  logic COUT4;

  // Signals for 8-bit adder
  logic [7:0] A8, B8;
  logic [7:0] SUM8;
  logic COUT8;

  // Signals for 16-bit adder
  logic [15:0] A16, B16;
  logic [15:0] SUM16;
  logic COUT16;

  // Instantiate ripple_carry_adder modules with different widths
  ripple_carry_adder #(`WIDTH_2) full_adder_2 (
    .a(A2), .b(B2), .cin(CIN), .sum(SUM2), .cout(COUT2)
  );
  ripple_carry_adder #(`WIDTH_4) full_adder_4 (
    .a(A4), .b(B4), .cin(CIN), .sum(SUM4), .cout(COUT4)
  );
  ripple_carry_adder #(`WIDTH_8) full_adder_8 (
    .a(A8), .b(B8), .cin(CIN), .sum(SUM8), .cout(COUT8)
  );
  ripple_carry_adder #(`WIDTH_16) full_adder_16 (
    .a(A16), .b(B16), .cin(CIN), .sum(SUM16), .cout(COUT16)
  );

  // Initial block for simulation
  initial begin
    // Set time format for display
    // Display time in nanoseconds with 1 decimal place, min width 10
    $timeformat(-9, 1, " ns", 6); 

    // Test 2-bit adder
    $display("=====================================");
    $display("        %0d-bit Full Adder Test", `WIDTH_2);
    $display("=====================================");
    $display(" Time    | A2 + B2 + Cin = SUM2 (COUT2)");
    $display("-------------------------------------");

    CIN = 0;
    #10;
    A2 = 2'b11; B2 = 2'b01;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A2, B2, CIN, SUM2, COUT2);

    CIN = 1;
    A2 = 2'b10; B2 = 2'b11;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A2, B2, CIN, SUM2, COUT2);

    A2 = 2'b00; B2 = 2'b00;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A2, B2, CIN, SUM2, COUT2);
    $display("-------------------------------------");

    // Test 4-bit adder
    $display("=====================================");
    $display("        %0d-bit Full Adder Test", `WIDTH_4);
    $display("=====================================");
    $display(" Time  | A4 + B4 + Cin = SUM4 (COUT4)");
    $display("-------------------------------------");

    CIN = 0;
    #10;
    A4 = 4'b0011; B4 = 4'b1010;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A4, B4, CIN, SUM4, COUT4);

    CIN = 1;
    A4 = 4'b1001; B4 = 4'b0110;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A4, B4, CIN, SUM4, COUT4);

    A4 = 4'hF; B4 = 4'hF;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A4, B4, CIN, SUM4, COUT4);
    $display("-------------------------------------");

    // Test 8-bit adder
    $display("=====================================");
    $display("        %0d-bit Full Adder Test", `WIDTH_8);
    $display("=====================================");
    $display(" Time    | A8 + B8 + Cin = SUM8 (COUT8)");
    $display("-------------------------------------");

    CIN = 0;
    #10;
    A8 = 8'h11; B8 = 8'h22;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A8, B8, CIN, SUM8, COUT8);

    CIN = 1;
    A8 = 8'hFF; B8 = 8'h01;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A8, B8, CIN, SUM8, COUT8);

    A8 = 8'hAA; B8 = 8'hCC;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A8, B8, CIN, SUM8, COUT8);
    $display("-------------------------------------");

    // Test 16-bit adder
    $display("=====================================");
    $display("        %0d-bit Full Adder Test", `WIDTH_16);
    $display("=====================================");
    $display(" Time    | A16 + B16 + Cin = SUM16 (COUT16)");
    $display("-------------------------------------");

    CIN = 0;
    #10;
    A16 = 16'hAAAA; B16 = 16'h5555;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A16, B16, CIN, SUM16, COUT16);

    CIN = 1;
    A16 = 16'hFFFF; B16 = 16'h0001;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A16, B16, CIN, SUM16, COUT16);

    A16 = 16'h1234; B16 = 16'h5678;
    #10;
    $display("%t | %b + %b + %b = %b (%b)", $time, A16, B16, CIN, SUM16, COUT16);
    $display("-------------------------------------");

    $display("=====================================");
    $finish; // End simulation
  end
endmodule
