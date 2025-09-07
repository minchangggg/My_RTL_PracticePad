// ===========================================
// Testbench for Full Adder Module
// This testbench verifies the behavior of the full_adder module
// by applying all possible 1-bit input combinations (2^3 = 8 cases) and monitoring outputs.
// ===========================================
module tb_full_adder;
  reg net_test_a;         // Input a for testing: First input bit
  reg net_test_b;         // Input b for testing: Second input bit
  reg net_test_cin;      // Input cin for testing: Carry-in bit
  wire net_test_sum;  // Output sum for testing: Result of the addition
  wire net_test_cout;  // Output cout for testing: Carry-out bit
 
  // Instantiate Full Adder module
  full_adder fa_test (
    .a(net_test_a),            // Connect test input a to module input a
    .b(net_test_b),            // Connect test input b to module input b
    .cin(net_test_cin),      // Connect test input cin to module input cin
    .sum(net_test_sum),  // Connect module output sum to test wire
    .cout(net_test_cout)   // Connect module output cout to test wire
  );

  // Initial block to perform test cases
  initial begin
    // Create VCD file for waveform analysis
    $dumpfile("dump.vcd"); 
    $dumpvars;

    $display("FA - Full Adder Test Results");
    $display("--------------------------------");

    // Display signal values at every change
    $monitor("Time=%0t, a=%b, b=%b, cin = %b, sum=%b, carry=%b", $time, net_test_a, net_test_b, net_test_cin, net_test_sum, net_test_cout);

    // Apply 8 input combinations
    net_test_a = 1'b0; net_test_b = 1'b0; net_test_cin = 1'b0; #10
    net_test_a = 1'b0; net_test_b = 1'b0; net_test_cin = 1'b1; #10

    net_test_a = 1'b0; net_test_b = 1'b1; net_test_cin = 1'b0; #10
    net_test_a = 1'b0; net_test_b = 1'b1; net_test_cin = 1'b1; #10

    net_test_a = 1'b1; net_test_b = 1'b0; net_test_cin = 1'b0; #10
    net_test_a = 1'b1; net_test_b = 1'b0; net_test_cin = 1'b1; #10

    net_test_a = 1'b1; net_test_b = 1'b1; net_test_cin = 1'b0; #10
    net_test_a = 1'b1; net_test_b = 1'b1; net_test_cin = 1'b1; #10

    // End simulation
    $finish;
  end
endmodule
