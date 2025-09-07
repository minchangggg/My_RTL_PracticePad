module tb_n_bit_adder;
  reg  [WIDTH-1:0] net_test_a, net_test_b;
  reg              net_test_cin;
  wire [WIDTH-1:0] net_test_sum;
  wire             net_test_cout;

  n_bit_adder uut (
    .a(net_test_a),
    .b(net_test_b),
    .cin(net_test_cin),
    .sum(net_test_sum),
    .cout(net_test_cout)
  );

  initial begin
    $dumpfile("adder.vcd");
    $dumpvars;

    $display("=======================================================");
    $display("            %d-bit Full Adder Test", WIDTH);
    $display("=======================================================");
    $display(" Time |  A  +  B  +  Cin  =  Sum  (Cout)");
    $display("-------------------------------------------------------");
    $monitor("%4t  | %b + %b + %b = %b (%b)", $time, net_test_a, net_test_b, net_test_cin, net_test_sum, net_test_cout);

    net_test_a = 4'b0000; net_test_b = 4'b0000; net_test_cin = 1'b0; #10;
    net_test_a = 4'b0011; net_test_b = 4'b1010; net_test_cin = 1'b1; #10;
    net_test_a = 4'b1001; net_test_b = 4'b0110; net_test_cin = 1'b1; #10;
    net_test_a = {WIDTH{1'b1}}; net_test_b = {WIDTH{1'b0}}; net_test_cin = 1'b0; #10;
    net_test_a = 4'hA; net_test_b = 4'hC; net_test_cin = 1'b1; #10;

    $finish;
  end
endmodule
