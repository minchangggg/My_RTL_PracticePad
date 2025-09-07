//
// Copyright 1991-2008 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//   

module test_bench;

    reg net_test_a, net_test_b;
    wire net_test_sum, net_test_carry;

    // Instantiate the Device Under Test (DUT)
    half_adder uut (
      .A(net_test_a),
      .B(net_test_b),
      .S(net_test_sum),
      .C(net_test_carry)
    );

    // Initial block to perform test cases
    initial begin
      // Create VCD file for waveform analysis
      $dumpfile("dump.vcd"); 
      $dumpvars;
      
      $display("HA - Half Adder Test Results");
      $display("--------------------------------");
      
      // Display signal values at every change
      $monitor("Time=%0t, a=%b, b=%b, sum=%b, carry=%b", $time, net_test_a, net_test_b, net_test_sum, net_test_carry);
      
      // Apply 4 input combinations
      net_test_a = 1'b0; net_test_b = 1'b0; #10;
      net_test_a = 1'b0; net_test_b = 1'b1; #10;
      net_test_a = 1'b1; net_test_b = 1'b0; #10;
      net_test_a = 1'b1; net_test_b = 1'b1; #10;
      
      // End simulation
      $finish;
    end

endmodule    
